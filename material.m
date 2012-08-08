classdef material
	properties
		% Name of the material for user convenience.
		name;
		% 'p' = p type
		% 'n' = n type
		% 'm' = metal
		typeCode;
		% Temperature of the material for calculating kT.
		temperature;
	end
	
	methods
		function obj = material(n, type, temp)
			obj.name = n;
			obj.typeCode = type;
			obj.temperature = temp;
		end
		
		function kT_eV = calc_kT_eV(obj)
			% From Wolfram|Alpha. Query was "Boltzmann constant in eV/K."
			Boltzmann_eV = 8.6173e-5;
			kT_eV = Boltzmann_eV * obj.temperature;
		end
		
		function kT_J = calc_kT_J(obj)
			% From Wolfram|Alpha. Query was "Boltzmann constant in J/K."
			Boltzmann_J = 1.38065e-23;
			kT_J = Boltzmann_J * obj.temperature;
		end
	end
	
	methods (Abstract)
		fermi = calcFermi(obj);
	end
end
