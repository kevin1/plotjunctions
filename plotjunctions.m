% PLOTJUNCTIONS: calculates and plots the energy of conduction and valence
% bands, Fermi levels, and potentials.
% All variables are 1D matricies with length of 2.
% name        - Name for material, present for user convenience
% E_ea        - Electron affinity (eV)
% E_g         - Band gap (eV)
% cc          - Carrier concentration (cm^-3)
% effectmass  - Effective mass, either Mp or Mn. (no units. don't include M_0)
% type        - A string ('n' or 'p') to specity which type is in this element.
% dielectric  - Relative dielectric constant
function plotjunctions(names, E_ea, E_g, cc, effectmass, type, dielectric)
% BEGIN CALCULATION

% E_val - energy of valence band
% E_cnd - energy of conduction band

% Assuming that global vacuum energy is 0 eV before the materials are touching.
E_vac = 0;

% Calculate conduction bands based on E_vac assumption, equation, and data
% passed in:
% E_electron_affinity = E_vacuum - E_conduction
E_cnd = E_vac - E_ea;

% Calculate valence bands based on equation and E_cndX calculation and data
% passed in:
% Econduction - Evalence = Egap
E_val = E_cnd - E_g;

% Calculate Fermi levels

% Prerequisite: Calculate kT in both eV and J. This is a global value.
% Note: If temperature becomes variable in the future, then this should be
% refactored to separate k and T into two variables.

% Assuming room temperature. According to _Solid State Electronic Devices_
% pg. 89, that makes kT 0.026 eV.
kT_eV = 0.026;
% From Wolfram|Alpha. Query was "Boltzmann constant * 300 K in J." I used 300 K
% because that's the value _Solid State Electronic Devices_ assumed for room
% temperature.
kT_J = 4.14195e-21;

% Mass of an electron in kg.
% From Wolfram|Alpha.
electronMass = 9.10938e-31;
% Multiplying the effective mass by the electron mass is the correct way to
% get the M* term. See references in function calcDensityStates() for an
% explanation.
effectmass = effectmass * electronMass;

% Prerequisite: Calculate the effective density of states.
N = calcDensityStates(effectmass, kT_J);

% Calculate Fermi level from the prerequisites.
E_fermi = zeros(1, 2);
% Loop through every element in the matrix type.
for t = 1:2
	currType = type(1, t);
	% Use the relevant (n or p) equation to calculate Fermi.
	if currType == 'n'
		calcFermi = calcFermiN(kT_eV, cc(1, t), N(1, t), E_cnd(1, t));
	elseif currType == 'p'
		calcFermi = calcFermiP(kT_eV, cc(1, t), N(1, t), E_val(1, t));
	else
		error('Invalid type "%c" in matrix "type" at index %d', currType, t)
	end
	% Set the Fermi level.
	E_fermi(1, t) = calcFermi;
end

% Calculate the absolute difference in Fermi levels.
deltaFermi = abs(E_fermi(1, 1) - E_fermi(1, 2));
% Make copies of the energy variables. Future expansion may require referencing
% unmoved levels (ones where E_val is zero).
E_val_plot = E_val;
E_cnd_plot = E_cnd;
E_fermi_plot = E_fermi;
% Align Fermi levels: for the material that currently has the higher Fermi level
% in our representation, move it down by deltaFermi.
if E_fermi(1, 1) < E_fermi(1, 2)
	E_val_plot(1, 2) = E_val_plot(1, 2) - deltaFermi;
	E_cnd_plot(1, 2) = E_cnd_plot(1, 2) - deltaFermi;
	E_fermi_plot(1, 2) = E_fermi_plot(1, 2) - deltaFermi;
else
	E_val_plot(1, 1) = E_val_plot(1, 1) - deltaFermi;
	E_cnd_plot(1, 1) = E_cnd_plot(1, 1) - deltaFermi;
	E_fermi_plot(1, 1) = E_fermi_plot(1, 1) - deltaFermi;
end

% The built-in potential is the difference between the Fermi levels.
V_bi = abs(E_fermi(1, 1) - E_fermi(1, 2));
% The applied voltage in this simulation will always be 0 V.
V_a = 0;
% Calculate the voltage drops on both sides of the junction.
deltaV(1, 1) = calcVoltageDrop1(V_bi, V_a, cc, dielectric);
deltaV(1, 2) = calcVoltageDrop1(V_bi, V_a, [cc(1, 2) cc(1, 1)], [dielectric(1, 2) dielectric(1, 1)]);
% Use the voltage drops to calculate the depletion widths.
depletionWidth = calcDepletionWidth1(dielectric, deltaV, cc);

% Number of samples to make when plotting voltage curves.
potPlotResolution = 1000;
% We need at least two points to draw a line. Also, a negative resolution does
% not make sense.
if potPlotResolution < 2
	error('potPlotResolution is too low. It needs to be at least 2.')
end

% Calculate the curves for band bending in the depletion area.
if E_fermi(1, 1) > E_fermi(1, 2)
	% Material that acts like p-type is material 1.
	i_actingP = 1;
	i_actingN = 2;
	
	% X-range for the first part is from the left end of the depletion area to
	% the center of the diagram.
	potPlot_x1 = (-1 * depletionWidth(1, 1)) : (depletionWidth(1, 1) / (potPlotResolution - 1)) : 0;
	% Calculate y-values based on those generated x-values.
	potPlot_y1 = calcVoltageCurve1(cc(1, 1), dielectric(1, 1), depletionWidth(1, 1), potPlot_x1);
	
	% Repeat the procedure for the second half of the curve.
	potPlot_x2 = 0 : (depletionWidth(1, 2) / (potPlotResolution - 1)) : depletionWidth(1, 2);
	potPlot_y2 = calcVoltageCurve2(V_bi, V_a, cc(1, 2), dielectric(1, 2), depletionWidth(1, 2), potPlot_x2);

else
	% P-type actor is material 2.
	i_actingP = 2;
	i_actingN = 1;
	
	% We multiply the y-values by -1 here because the q * N terms in the
	% calcVoltageCurve() functions need to be multiplied by -1.
	
	% X-range for the first part is from the left end of the depletion area to
	% the center of the diagram.
	potPlot_x1 = (-1 * depletionWidth(1, 1)) : (depletionWidth(1, 1) / (potPlotResolution - 1)) : 0;
	% Calculate y-values based on those generated x-values.
	potPlot_y1 = -1 * calcVoltageCurve1(cc(1, 1), dielectric(1, 1), depletionWidth(1, 1), potPlot_x1);
	
	% Repeat the procedure for the second half of the curve.
	potPlot_x2 = 0 : (depletionWidth(1, 2) / (potPlotResolution - 1)) : depletionWidth(1, 2);
	potPlot_y2 = -1 * calcVoltageCurve2(V_bi, V_a, cc(1, 2), dielectric(1, 2), depletionWidth(1, 2), potPlot_x2);
end

% BEGIN DRAWING

depletionTotal = sum(depletionWidth);

% Define the x-coordinates to start and stop plotting.
start = -1 * (depletionWidth(1, 1) + depletionTotal);
stop = depletionWidth(1, 2) + depletionTotal;

% Calculate x ranges where the bands will be plotted

% These calculations will divide the horizontal space into three sections:
% * 1/3 of the space for material 1
% * 1/3 of the space left empty
% * 1/3 of the space for material 2
width = stop - start;

xrange(:, 1) = [start,                  start + 1 * (width/3) ];
xrange(:, 2) = [start + 2 * (width/3),  stop                  ];

% MATLAB lets you specify a third argument in each set, which is a string that 
% may specify line style, color, data markers, or some combination of those.
% This will be passed into plot() to set the style of E_fermi lines.
E_fermi_style = '--';	% dashed line

% Create the figure and add material 1 to the figure
% MATLAB lets you specify a third argument in each set if you want to change the
% style of just that line.

plot(...
	xrange(:, 1), [E_val_plot(1, 1),   E_val_plot(1, 1)], ...
	xrange(:, 1), [E_cnd_plot(1, 1),   E_cnd_plot(1, 1)], ...
	xrange(:, 1), [E_fermi_plot(1, 1), E_fermi_plot(1, 1)], E_fermi_style ...
)
% Subsequent plot commands will modify the figure instead of replacing it.

% Add material 2 to the figure
plot(...
	xrange(:, 2), [E_val_plot(1, 2),   E_val_plot(1, 2)], ...
	xrange(:, 2), [E_cnd_plot(1, 2),   E_cnd_plot(1, 2)], ...
	xrange(:, 2), [E_fermi_plot(1, 2), E_fermi_plot(1, 2)], E_fermi_style ...
)

% Throw the left half of the curve onto the plot.
plotOffset = E_cnd_plot(1) - potPlot_y1(1);
% Plot the curve with our calculated offset.
potPlot_y1_cnd = potPlot_y1 + plotOffset;
plot(potPlot_x1, potPlot_y1_cnd, E_cnd_style)
% Future calls to plot() will go into the same figure.
hold on
% Calculate offset & plot.
plotOffset = E_val_plot(1) - potPlot_y1(1);
potPlot_y1_val = potPlot_y1 + plotOffset;
plot(potPlot_x1, potPlot_y1_val, E_val_style)

% Repeat procedure for the right half.
plotOffset = E_cnd_plot(2) - potPlot_y2(potPlotResolution);
potPlot_y2_cnd = potPlot_y2 + plotOffset;
plot(potPlot_x2, potPlot_y2_cnd, E_cnd_style)
plotOffset = E_val_plot(2) - potPlot_y2(potPlotResolution);
potPlot_y2_val = potPlot_y2 + plotOffset;
plot(potPlot_x2, potPlot_y2_val, E_val_style)

% Connect the potential curves with vertical lines.
plot(...
	[potPlot_x1(potPlotResolution) potPlot_x2(1)], ...
	[potPlot_y1_cnd(potPlotResolution) potPlot_y2_cnd(1)], ...
	E_cnd_style...
)
plot([potPlot_x1(potPlotResolution) potPlot_x2(1)], ...
	 [potPlot_y1_val(potPlotResolution) potPlot_y2_val(1)], E_val_style)

% Set window range
% Rationale: MATLAB can do this automatically by setting the bounds to the
% maximum and minimum values of the data being plotted. However, this is not the
% behavior we want, because some of our lines will become invisible when they
% are placed horizontally on the border of the figure.

% Make a matrix of the y values for convenience.
yvalues = [E_val_plot, E_cnd_plot, E_fermi_plot, ...
	potPlot_y1_cnd, potPlot_y1_val, potPlot_y2_cnd, potPlot_y2_val];
% Find maximum and minimum y values.
% Using nested calls to min() and max() because we are passing in 2-D matricies,
% which return 1-D matricies of the min/max in each column. So to get the
% min/max of all the elements, we run min()/max() on the 1-D matrix.
ymin = min(min(yvalues));
ymax = max(max(yvalues));

plot_xmin = start - depletionTotal;
plot_xmax = stop + depletionTotal;
% Space to leave blank on the top and bottom of the figure.
ypad = (ymax - ymin) / 4;
plot_ymin = ymin - ypad;
plot_ymax = ymax + ypad;
% Set the window range
axis([plot_xmin, plot_xmax, plot_ymin, plot_ymax])

% labels
% Material names
% Print them so that the x-values are in the middle of the flat area
text(mean(xrange(:, 1)), ymax, names(1), ...
	'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(mean(xrange(:, 2)), ymax, names(2), ...
	'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
% Depletion
text(-1 * depletionWidth(1)/2, ymax, ...
	num2str(depletionWidth(1) * 1e7, '%.1f nm'), ...
	'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
% For some reason, MATLAB will not let me display the same label twice here. (It
% works in the material names code.) To get around it, we display '(same)' for
% the second depletion width if the two are the same.
if depletionWidth(1) ~= depletionWidth(2)
	depletionWidth2Disp = num2str(depletionWidth(2) * 1e7, '%.1f nm');
else
	depletionWidth2Disp = '(same)';
end
text(depletionWidth(2)/2, ymax, depletionWidth2Disp, ...
	'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
% Built-in potential
text(plot_xmax, plot_ymin, sprintf('V_{bi}: %g V', V_bi), ...
	'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
% Maximum open circuit voltage
text(plot_xmin, plot_ymin, ...
	sprintf('Maximum V_{OC}: %g V', ...
		E_cnd_plot(i_actingN) - E_val_plot(i_actingP)), ...
	'VerticalAlignment', 'bottom')

% Add x-axis label
xlabel('Position (cm)')

% Add y-axis label
ylabel('Energy (eV)')

end

function N = calcDensityStates(M, kT)
%CALCDENSITYSTATES Summary of this function goes here
%   Detailed explanation goes here

% Planck's constant, 6.63x10^-34 J-s, from _Solid State Electronic Devices_,
% page 40.
planck = 6.63e-34;

% Based on _Solid State Electronic Devices_, equations 3-16a and 3-20.
N = 2 * ( (2 .* pi .* M .* kT) / (planck ^ 2) ) .^ (3/2);

% N is in m^-3, so we convert to cm^-3.
N = N / (100 ^ 3);

end

function E_f = calcFermiN(kT_eV, cc, N, E_cnd)
% Based on _Solid State Electronic Devices_, equation 3-15.
% Assumes E_f < E_cnd by several kT_eV.
% Note: In MATLAB, log() is the natural logarithm, not the common logarithm.
E_f = kT_eV .* log(cc ./ N) + E_cnd;	% n-type
end

function E_f = calcFermiP(kT_eV, cc, N, E_val)
% Based on _Solid State Electronic Devices_, equation 3-19.
% Assumes E_f > E_val by several kT_eV.
% Note: In MATLAB, log() is the natural logarithm, not the common logarithm.
E_f = E_val - kT_eV .* log(cc ./ N);	% p-type

end

% Returns the voltage drop on the side of the junction specified by index 1 in
% N and Eps_r.
function voltDrop = calcVoltageDrop1(V_bi, V_a, N, Eps_r)
% Based on "Heterostructure Fundamentals" Mark Lundstrom, equations 30 and 31.
voltDrop = (V_bi - V_a) * ( (Eps_r(1, 2) * N(1, 2)) / (Eps_r(1, 1) * N(1, 1) + Eps_r(1, 2) * N(1, 2)) );
end

function depWidth = calcDepletionWidth1(Eps_r, V, N)
% From Wolfram|Alpha, query was "dielectric constant of vacuum in F/cm"
% Electric constant in Farads / cm
Eps_0 = 8.854e-14;
% From Wolfram|Alpha, query was "charge of an electron in coulombs"
% Charge of an electron in Coulombs
q = 1.6021766e-19;
% Based on "Heterostructure Fundamentals" Mark Lundstrom, equations 32 and 33.
depWidth = sqrt( (2 * Eps_r .* Eps_0 .* V) ./ (q .* N) );
end

function V = calcVoltageCurve1(N, Eps_r, depletionWidth, x)
% From Wolfram|Alpha, query was "dielectric constant of vacuum in F/cm"
% Electric constant in Farads / cm
Eps_0 = 8.854e-14;
% From Wolfram|Alpha, query was "charge of an electron in coulombs"
% Charge of an electron in Coulombs
q = 1.6021766e-19;
% Based on "Heterostructure Fundamentals" Mark Lundstrom, equation 23.
V = (q * N(1, 1)) / (2 * Eps_r * Eps_0) * (x + depletionWidth) .^ 2;
end

function V = calcVoltageCurve2(V_bi, V_a, N, Eps_r, depletionWidth, x)
% From Wolfram|Alpha, query was "dielectric constant of vacuum in F/cm"
% Electric constant in Farads / cm
Eps_0 = 8.854e-14;
% From Wolfram|Alpha, query was "charge of an electron in coulombs"
% Charge of an electron in Coulombs
q = 1.6021766e-19;
% Based on "Heterostructure Fundamentals" Mark Lundstrom, equation 24.
V = (V_bi - V_a) - (q * N) / (2 * Eps_r * Eps_0) * (depletionWidth - x) .^ 2;
end
