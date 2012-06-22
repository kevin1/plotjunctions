% plotbands: calculates and plots the energy of conduction and valence bands, 
% plus the Fermi levels.
% All variables are 1D matricies with length of 2.
% Index (1, 1) is for p-type material.
% Index (1, 2) is for n-type material.
% name - Name for material, present for user convenience
% E_ea - Electron affinity
% E_g  - Band gap
% cc   - Carrier concentration
function plotbands(names, E_ea, E_g, cc)
% BEGIN CALCULATION

% E_valX - energy of valence band in material X
% E_cndX - energy of conduction band in material X

% Assuming that global vacuum energy is 0 eV because the materials haven't
% touched yet.
E_vac = 0;

% Calculate conduction bands based on E_vac assumption, equation, and data
% passed in:
% E_electron_affinity = E_vacuum - E_conduction
% TODO: this might be easier / less stupid with matrix math
E_cnd = E_vac - E_ea

% Calculate valence bands based on equation and E_cndX calculation and data
% passed in:
% Econduction - Evalence = Egap
E_val = E_cnd - E_g

% Calculate Fermi levels

% Prerequisite: Calculate kT. This is a global value.
% Assuming room temperature. According to _Solid State Electronic Devices_
% pg. 89, that makes kT 0.026 eV.
% Note: If temperature becomes variable in the future, then this should be
% refactored to separate k and T into two variables.
kT = 0.026

% Prerequisite: Calculate the effective density of states.
% Based on _Solid State Electronic Devices_, equation 3-16a.
%N(1, 1) = 
%N(1, 2) = 
N = [1, 1]	% TODO: fix this stupidity

% Calculate Fermi level from the prerequisites.
% Based on _Solid State Electronic Devices_, equation 3-15.
% Note: In MATLAB, log() is the natural logarithm, not the common logarithm.
E_fermi = kT * log(cc ./ N) + E_cnd

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
