classdef junction2 < junction
	properties
		
	end
	
	methods (Abstract)
		calcVbi(obj)
		calcVoltageDrop(obj)
		calcDepletionWidth(obj)
		calcVoltageCurve(obj, resolution)
		calcVoltageCurvePart(obj, materialIndex, xvals)
	end
end
