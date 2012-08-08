classdef junction2 < junction
	properties
		
	end
	
	methods (Abstract)
		calcVbi(obj)
		calcVoltageDrop(obj)
		calcDepletionWidth(obj)
		calcVoltageCurve(obj, materialIndex, resolution)
	end
end
