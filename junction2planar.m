classdef junction2planar < junction2
	properties
		
	end
	
	methods
		function obj = junction2planar(material1, material2)
			obj.materials = [material1, material2];
			obj.V_a = 0;
		end
		
		function plot(obj)
			
		end
		
		function V_bi = calcVbi(obj)
			% The built-in potential is the difference between the Fermi levels.
			V_bi = abs(obj.materials(1).calcFermi() - obj.materials(2).calcFermi());
		end
		
		function voltDrop = calcVoltageDrop(obj, materialIndex)
			% Based on "Heterostructure Fundamentals" Mark Lundstrom, equations 30 and 31.
			switch materialIndex
				case 1
					indexA = 2;
					indexB = 1;
				case 2
					indexA = 1;
					indexB = 2;
			end
			
			a = obj.materials(indexA);
			b = obj.materials(indexB);
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
		
		function curve = calcVoltageCurve(obj, resolution)
			% We need at least two points to draw a line. Also, a negative resolution does
			% not make sense.
			assert(resolution >= 2)
			
			% X-range for the first part is from the left end of the depletion area to
			% the center of the diagram.
			potPlot_x1 = (-1 * obj.calcDepletionWidth(1)) : (obj.calcDepletionWidth(1) / (resolution - 1)) : 0;
			% Rinse and repeat.
			potPlot_x2 = 0 : (obj.calcDepletionWidth(2) / (resolution - 1)) : obj.calcDepletionWidth(2);
			
			% Calculate the curves for band bending in the depletion area.
			if obj.materials(1).calcFermi() > obj.materials(2).calcFermi()
				% Material that acts like p-type is material 2.
				i_actingP = 2;
				i_actingN = 1;
				
				% Calculate y-values based on those generated x-values.
				potPlot_y1 = obj.calcVoltageCurvePart(1, potPlot_x1);
				
				% Repeat the procedure for the second half of the curve.
				potPlot_y2 = obj.calcVoltageCurvePart(2, potPlot_x2);
				
			else
				% P-type actor is material 1.
				i_actingP = 1;
				i_actingN = 2;
				
				% We multiply the y-values by -1 here because the q * N terms in the
				% calcVoltageCurve() functions need to be multiplied by -1.
				
				% Calculate y-values based on those generated x-values.
				potPlot_y1 = -1 * obj.calcVoltageCurvePart(1, potPlot_x1);
				
				% Repeat the procedure for the second half of the curve.
				potPlot_y2 = -1 * obj.calcVoltageCurvePart(2, potPlot_x2);
			end
			
			curve = horzcat(potPlot_y1, potPlot_y2);
		end
		
		function V = calcVoltageCurvePart(obj, materialIndex, xvals)
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