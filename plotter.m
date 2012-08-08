classdef plotter
	properties (Constant)
		
	end
	
	methods (Static)
		function draw(job)
			assert(job.validate())
			
			bulkAligned = plotter.alignBulk(job);
			
			widthBendCalib = min(job.bandBendsSizes);
			widthBulk = widthBendCalib * 2;
			
			% MATLAB lets you specify a third argument in each set, which is a string that 
			% may specify line style, color, data markers, or some combination of those.
			% This will be passed into plot() to set the style of lines.
			% May consider moving this into the plotjob class.
			styleVal = '-b';		% solid blue
			styleCnd = '-g';		% solid green
			styleFermi = '--r';		% dashed red
			
			plotLocX = 0;
			
			i_bulk = 1;
			i_bend = 1;
			for i = 1 : job.numMaterials() + length(job.bandBendsSizes)
				if mod(i, 3) == 1
					% Plotting bulk material
					xrange = [plotLocX, plotLocX + widthBulk];
					
					c = bulkAligned(i_bulk).cnd;
					v = bulkAligned(i_bulk).val;
					f = bulkAligned(i_bulk).fermi;
					
					plot(...
						xrange, [c, c], styleCnd,  ...
						xrange, [v, v], styleVal,  ...
						xrange, [f, f], styleFermi ...
					)
					
					i_bulk = i_bulk + 1;
				else
					% Plotting band bending
					xrange = [plotLocX, plotLocX + job.bandBendsSizes(i_bend)];
					
					% Generate x-values
					xwidth = xrange(2) - xrange(1);
					resolution = length(job.bandBends(:, i_bend))
					xinterval = xwidth / resolution;
					x = xrange(1) : xinterval : xrange(2) - xinterval;
					
					yraw = transpose(job.bandBends(:, i_bend));
					
					if mod(i, 3) == 2
						errorCnd = bulkAligned(i_bend).cnd - yraw(1);
						errorVal = bulkAligned(i_bend).val - yraw(1);
					else
						errorCnd = bulkAligned(i_bend).cnd - yraw(resolution);
						errorVal = bulkAligned(i_bend).val - yraw(resolution);
					end
					
					plot(...
						x, yraw + errorCnd, styleCnd, ...
						x, yraw + errorVal, styleVal  ...
					)
					
					i_bend = i_bend + 1;
				end
				
				hold on
				plotLocX = xrange(2);
			end
		end
		
		function aligned = alignBulk(job)
			% Extract data from object
			% Preallocation of arrays improves performance.
			fermi = zeros(1, job.numMaterials());
			for i = 1 : job.numMaterials()
				fermi(i) = job.materials(i).calcFermi();
			end
			
			% Calculate and save aligned Fermi levels.
			minFermi = min(fermi);
			aligned(job.numMaterials()).cnd = 0;
			aligned(job.numMaterials()).val = 0;
			aligned(job.numMaterials()).fermi = 0;
			for i = 1 : job.numMaterials()
				diff = minFermi - fermi(i);
				
				aligned(i).cnd = job.materials(i).calcBandCnd() + diff;
				aligned(i).val = job.materials(i).calcBandVal() + diff;
				aligned(i).fermi = job.materials(i).calcFermi() + diff;
			end
		end
		
	end
end