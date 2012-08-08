classdef plotter
	properties (Constant)
		
	end
	
	methods (Static)
		function draw(job)
			assert(job.validate())
			
			% Align the Fermi levels of the bulk areas.
			bulkAligned = plotter.alignBulk(job);
			
			% Calibrate the width of the bulk area to be twice the width of the
			% smallest band bending area.
			widthBendCalib = min(job.bandBendsSizes);
			widthBulk = widthBendCalib * 2;
			
			% MATLAB lets you specify a third argument in each set, which is a string that 
			% may specify line style, color, data markers, or some combination of those.
			% This will be passed into plot() to set the style of lines.
			% May consider moving this into the plotjob class.
			styleVal = '-b';		% solid blue
			styleCnd = '-g';		% solid green
			styleFermi = '--r';		% dashed red
			
			% Begin plotting at x = 0.
			plotBeginX = 0;
			% Initalize current plotting location to the begin location.
			plotLocX = plotBeginX;
			
			% Current indicies for bulk plotting and bend plotting. (They are
			% handled by separate lists.)
			i_bulk = 1;
			i_bend = 1;
			% Make a new figure for this to go into.
			figure()
			% For each section (bulk or bend) that needs to be plotted
			for i = 1 : job.numMaterials() + length(job.bandBendsSizes)
				% Assume x = mod(i, 3).
				% x == 1, then plot bulk
				% x == 2, then plot bend (left side)
				% x == 0, then plot bend (right side)
				if mod(i, 3) == 1
					% Plotting bulk material
					
					% Calculate the x-range that this section will occupy.
					xrange = [plotLocX, plotLocX + widthBulk];
					
					% Shortcuts for the bands.
					c = bulkAligned(i_bulk).cnd;
					v = bulkAligned(i_bulk).val;
					f = bulkAligned(i_bulk).fermi;
					
					% Plot. This essentially draws styled horizontal lines.
					plot(...
						xrange, [c, c], styleCnd,  ...
						xrange, [v, v], styleVal,  ...
						xrange, [f, f], styleFermi ...
					)
					
					% Increment the index so that we plot the next bulk area the
					% next time this section of code is run.
					i_bulk = i_bulk + 1;
					
				else
					% Plotting band bending
					
					% Calculate the x-range that this section will occupy.
					xrange = [plotLocX, plotLocX + job.bandBendsSizes(i_bend)];
					
					% Generate x-values
					xwidth = xrange(2) - xrange(1);
					% Match the resolution of the job.
					resolution = length(job.bandBends(:, i_bend));
					xinterval = xwidth / resolution;
					
					x = xrange(1) : xinterval : (xrange(2) - xinterval);
					
					% Get raw y-values from the job.
					yraw = transpose(job.bandBends(:, i_bend));
					
					% Figure out which bulk we are aligning with.
					if mod(i, 3) == 2
						errorCnd = bulkAligned(i_bulk - 1).cnd - yraw(1);
						errorVal = bulkAligned(i_bulk - 1).val - yraw(1);
					else
						errorCnd = bulkAligned(i_bulk).cnd - yraw(resolution);
						errorVal = bulkAligned(i_bulk).val - yraw(resolution);
					end
					
					% Put it onto the plot.
					plot(...
						x, yraw + errorCnd, styleCnd, ...
						x, yraw + errorVal, styleVal  ...
					)
					
					% Increment the index.
					i_bend = i_bend + 1;
				end
				
				% Future calls to plot() will not replace the figure or spawn
				% new figures.
				hold on
				% Update the current plotting location.
				plotLocX = xrange(2);
			end
		end
		
		function aligned = alignBulk(job)
			% Extract data from job
			% Preallocation of arrays improves performance.
			fermi = zeros(1, job.numMaterials());
			% Extract Fermi levels from job.
			for i = 1 : job.numMaterials()
				fermi(i) = job.materials(i).calcFermi();
			end
			
			% Calculate and save aligned Fermi levels.
			% Find smallest Fermi -- all others will be aligned with this.
			minFermi = min(fermi);
			% Preallocation.
			aligned(job.numMaterials()).cnd = 0;
			aligned(job.numMaterials()).val = 0;
			aligned(job.numMaterials()).fermi = 0;
			% Calculate the distance to shift each material and save the shifted
			% value.
			for i = 1 : job.numMaterials()
				diff = minFermi - fermi(i);
				
				aligned(i).cnd = job.materials(i).calcBandCnd() + diff;
				aligned(i).val = job.materials(i).calcBandVal() + diff;
				aligned(i).fermi = job.materials(i).calcFermi() + diff;
			end
		end
		
	end
end