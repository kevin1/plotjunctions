classdef metal < material
	properties
		workfunction;
	end
	
	methods
		function obj = metal(n, temp, wf)
			obj = obj@material(n, 'm', temp);
			
			obj.temperature = temp;
			obj.workfunction = wf;
		end
		
		function fermi = calcFermi(obj)
			fermi = 0 - obj.workfunction;
		end
	end
end
