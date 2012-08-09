classdef junction2 < junction
	properties
		
	end
	
	methods (Abstract)
		calcVbi(obj)
		calcVoltageDrop(obj)
		calcDepletionWidth(obj)
		calcVoltageCurve(obj, materialIndex, resolution)
	end
	
	methods
		function p = getActorP(obj)
			if obj.materials(1).calcFermi() < obj.materials(2).calcFermi()
				p = 1;
			else
				p = 2;
			end
		end
		
		function n = getActorN(obj)
			if obj.getActorP() == 1
				n = 2;
			else
				n = 1;
			end
		end
	end
end
