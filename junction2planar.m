classdef junction2planar < junction2
	properties
		
	end
	
	methods
		function obj = junction2planar(material1, material2)
			obj.materials = [material1, material2];
			obj.V_a = 0;
		end
		
		function plot(obj)
			% Band bending on the side of material 1.
			bends(:, 1) = transpose(obj.calcVoltageCurve(1, 1000));
			% Ditto, material 2.
			bends(:, 2) = transpose(obj.calcVoltageCurve(2, 1000));
			% Calculate depletion width to know how big to draw band bending.
			bendsSizes = [obj.calcDepletionWidth(1), obj.calcDepletionWidth(2)];
			
			% Tell plotter to make a pretty picture.
			plotter.draw(plotjob(obj.materials, bends, bendsSizes));
		end
		
		function V_bi = calcVbi(obj)
			% The built-in potential is the difference between the Fermi levels.
			V_bi = abs(obj.materials(1).calcFermi() - obj.materials(2).calcFermi());
		end
		
		function voltDrop = calcVoltageDrop(obj, materialIndex)
			% Information about both materials is required in this function, so
			% we need to figure out which one is which based on the argument.
			switch materialIndex
				case 1
					indexA = 2;
					indexB = 1;
				case 2
					indexA = 1;
					indexB = 2;
			end
			
			% For code brevity.
			a = obj.materials(indexA);
			b = obj.materials(indexB);
			
			% Based on "Heterostructure Fundamentals" Mark Lundstrom, equations 30 and 31.
			voltDrop = (obj.calcVbi() - obj.V_a) * ( (b.dielectric * b.carrierConcentration) / (a.dielectric * a.carrierConcentration + b.dielectric * b.carrierConcentration) );
		end
		
		function depWidth = calcDepletionWidth(obj, materialIndex)
			% From Wolfram|Alpha, query was "dielectric constant of vacuum in F/cm"
			% Electric constant in Farads / cm
			Eps_0 = 8.854e-14;
			% From Wolfram|Alpha, query was "charge of an electron in coulombs"
			% Charge of an electron in Coulombs
			q = 1.6021766e-19;
			% Based on "Heterostructure Fundamentals" Mark Lundstrom, equations 32 and 33.
			depWidth = sqrt( (2 * obj.materials(materialIndex).dielectric .* Eps_0 .* obj.calcVoltageDrop(materialIndex)) ./ (q .* obj.materials(materialIndex).carrierConcentration) );
		end
		
		function y = calcVoltageCurve(obj, materialIndex, resolution)
			% We need at least two points to draw a line. Also, a negative resolution does
			% not make sense.
			assert(resolution >= 2)
			
			% Generate some x-values.
			switch materialIndex
				case 1
					% X-range for the first part is from the left end of the depletion area to
					% the center of the diagram.
					x = (-1 * obj.calcDepletionWidth(1)) : (obj.calcDepletionWidth(1) / (resolution - 1)) : 0;
				case 2
					% Rinse and repeat.
					x = 0 : (obj.calcDepletionWidth(2) / (resolution - 1)) : obj.calcDepletionWidth(2);
			end
			
			% Calculate some y-values from those x-values.
			y = obj.calcVoltageCurveData(materialIndex, x);
			
			% If the p-type actor is materials 1
			if obj.materials(1).calcFermi() < obj.materials(2).calcFermi()
				% We multiply the y-values by -1 here because the q * N terms in the
				% calcVoltageCurve() functions need to be multiplied by -1.
				y = -1 * y;
			end
		end
		
		function V = calcVoltageCurveData(obj, materialIndex, xvals)
			% From Wolfram|Alpha, query was "dielectric constant of vacuum in F/cm"
			% Electric constant in Farads / cm
			Eps_0 = 8.854e-14;
			% From Wolfram|Alpha, query was "charge of an electron in coulombs"
			% Charge of an electron in Coulombs
			q = 1.6021766e-19;
			
			switch materialIndex
				case 1
					% Based on "Heterostructure Fundamentals" Mark Lundstrom, equation 23.
					V = (q * obj.materials(materialIndex).carrierConcentration) / (2 * obj.materials(materialIndex).dielectric * Eps_0) * (xvals + obj.calcDepletionWidth(materialIndex)) .^ 2;
				case 2
					% Based on "Heterostructure Fundamentals" Mark Lundstrom, equation 24.
					V = (obj.calcVbi() - obj.V_a) - (q * obj.materials(materialIndex).carrierConcentration) / (2 * obj.materials(materialIndex).dielectric * Eps_0) * (obj.calcDepletionWidth(materialIndex) - xvals) .^ 2;
			end
		end
		
	end
end
