classdef junction
	properties
		% List of the materials in this junction
		materials
		% Applied voltage
		V_a
	end
	
	methods (Abstract)
		plot(obj)
	end
end
