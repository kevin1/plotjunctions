% plotbands: calculates and plots the energy of conduction and valence bands, 
% plus the Fermi levels.
% All variables are 1D matricies with length of 2.
% name        - Name for material, present for user convenience
% E_ea        - Electron affinity (eV)
% E_g         - Band gap (eV)
% cc          - Carrier concentration (cm^-3)
% effectmass  - Effective mass, either Mp or Mn. (no units. don't include M_0)
% type        - A string ('n' or 'p') to specity which type is in this element.
function plotbands(names, E_ea, E_g, cc, effectmass, type)
% BEGIN CALCULATION

% E_val - energy of valence band
% E_cnd - energy of conduction band

% Assuming that global vacuum energy is 0 eV because the materials haven't
% touched yet.
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
% From Wolfram|Alpha. Query was "Boltzmann constant * 300 K in J." I used
% 300 K because that's the value _Solid State Electronic Devices_ assumed
% for room temperature.
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
for t = 1:2
	if type(1, t) == 'n'
		E_fermi(1, t) = calcFermiN(kT_eV, cc(1, t), N(1, t), E_cnd(1, t));
	elseif type(1, t) == 'p'
		E_fermi(1, t) = calcFermiP(kT_eV, cc(1, t), N(1, t), E_val(1, t));
	end
end

% BEGIN DRAWING

% Define the plotting area.
start = -1.5;	% X location to start plotting the diagram
stop = 1.5;	% X location to stop plotting the diagram

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
	xrange(:, 1), [E_val(1, 1),   E_val(1, 1)], ...
	xrange(:, 1), [E_cnd(1, 1),   E_cnd(1, 1)], ...
	xrange(:, 1), [E_fermi(1, 1), E_fermi(1, 1)], E_fermi_style ...
)
% Subsequent plot commands will modify the figure instead of replacing it.
hold on
% Add material 2 to the figure
plot(...
	xrange(:, 2), [E_val(1, 2),   E_val(1, 2)], ...
	xrange(:, 2), [E_cnd(1, 2),   E_cnd(1, 2)], ...
	xrange(:, 2), [E_fermi(1, 2), E_fermi(1, 2)], E_fermi_style ...
)

% Set window range
% Rationale: MATLAB can do this automatically by setting the bounds to the
% maximum and minimum values of the data being plotted. However, this is not the
% behavior we want, because some of our lines will become invisible when they
% are placed horizontally on the border of the figure.

% Make a matrix of the y values for convenience.
yvalues = [E_val(1, 1), E_cnd(1, 1), E_fermi(1, 1), ...
           E_val(1, 2), E_cnd(1, 2), E_fermi(1, 2)];
% Set the window range
axis([ ...
	start - 1,         stop + 1,        ... % xmin, xmax
	min(yvalues) - 1,  max(yvalues) + 1 ... % ymin, ymax
])

% Add labels for energy levels
% TODO

% Add x-axis label
xlabel('Position (unit?)')	% TODO

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
