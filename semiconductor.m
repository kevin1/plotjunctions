classdef semiconductor < material
	properties
		vacuum;
		electronAffinity;
		bandGap;
		carrierConcentration;
		effectiveMass;
		dielectric;
	end
	
	methods
		function obj = semiconductor(n, type, temp, E_vac, E_ea, E_g, cc, em, Eps_r)
			% Call superclass constructor.
			obj = obj@material(n, type, temp);
			
			% Construct the object.
			% Save values to properties.
			obj.vacuum = E_vac;
			obj.electronAffinity = E_ea;
			obj.bandGap = E_g;
			obj.carrierConcentration = cc;
			% Mass of an electron in kg.
			% From Wolfram|Alpha.
			electronMass = 9.10938e-31;
			% Multiplying the effective mass by the electron mass is the correct way to
			% get the M* term. See references in function calcDensityStates() for an
			% explanation.
			obj.effectiveMass = em * electronMass;
			obj.dielectric = Eps_r;
		end
		
		function N = calcDensityStates(obj)
			% TODO
			%CALCDENSITYSTATES Summary of this function goes here
			%   Detailed explanation goes here

			% Planck's constant, 6.63x10^-34 J-s, from _Solid State Electronic Devices_,
			% page 40.
			planck = 6.63e-34;

			% Based on _Solid State Electronic Devices_, equations 3-16a and 3-20.
			N = 2 * ( (2 .* pi .* obj.effectiveMass .* obj.calc_kT_J()) / (planck ^ 2) ) .^ (3/2);

			% N is in m^-3, so we convert to cm^-3.
			N = N / (100 ^ 3);
		end
		
		function fermi = calcFermi(obj)
			switch obj.typeCode
				case 'n'
					% Based on _Solid State Electronic Devices_, equation 3-15.
					% Assumes E_f < E_cnd by several kT_eV.
					% Note: In MATLAB, log() is the natural logarithm, not the common logarithm.
					fermi = obj.calc_kT_eV() .* log(obj.carrierConcentration ./ obj.calcDensityStates()) + obj.calcBandCnd();
				case 'p'
					% Based on _Solid State Electronic Devices_, equation 3-19.
					% Assumes E_f > E_val by several kT_eV.
					% Note: In MATLAB, log() is the natural logarithm, not the common logarithm.
					fermi = obj.calcBandVal() - obj.calc_kT_eV() .* log(obj.carrierConcentration ./ obj.calcDensityStates());
			end
		end
		
		function E_cnd = calcBandCnd(obj)
			E_cnd = obj.vacuum - obj.electronAffinity;
		end
		
		function E_val = calcBandVal(obj)
			E_val = obj.calcBandCnd() - obj.bandGap;
		end
	end
end
