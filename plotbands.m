% plotbands: calculates and plots the energy of conduction and valence bands, 
% plus the Fermi levels.
% nameX - Name for material X, present for user convenience
% E_eaX - Electron affinity for material X
% E_gX  - Band gap for material X
% ccX   - Carrier concentration for material X
%         Positive for p-type
%         Negative for n-type
function plotbands(name1, E_ea1, E_g1, cc1, name2, E_ea2, E_g2, cc2)
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
E_cnd1 = E_vac - E_ea1;
E_cnd2 = E_vac - E_ea2;

% Calculate valence bands based on equation and E_cndX calculation and data
% passed in:
% Econduction - Evalence = Egap
E_val1 = E_cnd1 - E_g1;
E_val2 = E_cnd2 - E_g2;

% Calculate Fermi levels
% TODO look in book to find out how to do this. carrier concentration?
E_fermi1 = -5.4;
E_fermi2 = -4.9;


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
xrange1 = [start,                  start + 1 * (width/3) ];
xrange2 = [start + 2 * (width/3),  stop                  ];

% MATLAB lets you specify a third argument in each set, which is a string that 
% may specify line style, color, data markers, or some combination of those.
% This will be passed into plot() to set the style of E_fermi lines.
E_fermi_style = '--';	% dashed line

% Create the figure and add material 1 to the figure
% MATLAB lets you specify a third argument in each set if you want to change the
% style of just that line.
plot(...
	xrange1, [E_val1,   E_val1], ...
	xrange1, [E_cnd1,   E_cnd1], ...
	xrange1, [E_fermi1, E_fermi1], E_fermi_style ...
)
% Subsequent plot commands will modify the figure instead of replacing it.
hold on
% Add material 2 to the figure
plot(...
	xrange2, [E_val2, E_val2], ...
	xrange2, [E_cnd2, E_cnd2], ...
	xrange2, [E_fermi2, E_fermi2], E_fermi_style ...
)

% Set window range
% Rationale: MATLAB can do this automatically by setting the bounds to the
% maximum and minimum values of the data being plotted. However, this is not the
% behavior we want, because some of our lines will become invisible when they
% are placed horizontally on the border of the figure.

% Make a matrix of the y values for convenience.
yvalues = [E_val1, E_cnd1, E_fermi1, E_val2, E_cnd2, E_fermi2];
% Set the window range
axis([ ...
	start - 1,         stop + 1,        ... % xmin, xmax
	min(yvalues) - 1,  max(yvalues) + 1 ... % ymin, ymax
])

% Add labels for energy levels
% TODO

% Add x-axis label
xlabel('Position ()')

% Add y-axis label
ylabel('Energy (eV)')

end
