classdef plotjob
	properties
		materials
		bandBends
		bandBendsSizes
	end
	
	methods
		function obj = plotjob(materialsList, bandBendsList, bandBendsSizesList)
			obj.materials = materialsList;
			obj.bandBends = bandBendsList;
			obj.bandBendsSizes = bandBendsSizesList;
		end
		
		function isValid = validate(obj)
			% Check the integrity of the data.
			dimMat = size(obj.materials);
			dimBend = size(obj.bandBends);
			dimBendSize = size(obj.bandBendsSizes);
			
			% All of the following statements must be true for the job to be valid.
			% Number of materials specified by each matrix is consistent.
			isValid = ((dimMat(2) - 1) * 2 == dimBend(2) & dimBend(2) == dimBendSize(2));
			% There are at least two materials.
			isValid = isValid & (dimMat(2) >= 2);
			% Height of the matrix == 1.
			isValid = isValid & (dimMat(1) == 1 & dimBendSize(1) == 1);
		end
		
		function num = numMaterials(obj)
			if obj.validate()
				num = size(obj.materials);
				num = num(2);
			else
				num = -1;
			end
		end
	end
end