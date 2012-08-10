classdef junction
	properties
		% List of the materials in this junction
		materials
		% Applied voltage
		V_a
	end
	
	methods (Abstract)
		% Call this method to tell the junction to plot itself.
		plot(obj)
	end
end
