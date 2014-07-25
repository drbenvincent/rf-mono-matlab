classdef dataset
	%% DATASET An object for the dataset
	% Detailed exlanation here

	% public properties
%     properties
% 		patchsize
% 	end
	
	% read-only properties
	properties(GetAccess='public', SetAccess='private')
		filename
		nImages
		input_image_size
	end
	
	% protected, i.e. not visible from outside
    properties(Access = protected)
		imagedata
		counter
	end
	
    methods
        
        function obj=dataset(filename)
			% Class constructor
            load(filename)
            obj.imagedata = IMAGES;
            
            obj.filename = filename;
            obj.nImages  = size(obj.imagedata,2);
            obj.counter  = 1;
			obj.input_image_size = size(obj.imagedata,1);
			display('dataset object created')
        end
        
        function obj = increment_counter_by(obj, increment)
            obj.counter = obj.counter+increment;
		end
		
		function obj = shuffleImages(obj)
			% shuffles the order of images
			shuffledOrder	= randperm(obj.nImages);
			obj.imagedata	= obj.imagedata(:,shuffledOrder);
		end
		
		function [someImages, obj] = giveMeSomeImages(obj,N)
			% get the images [counter : counter+N]. 
			someImages = obj.imagedata(:, [obj.counter : obj.counter+N]);
			% increment the counter
			obj.counter = obj.counter+N;
		end
		
		function [someImages, obj] = giveMeSomeRandomImages(obj,N)
			shuffledOrder	= randperm(obj.nImages);
			someImages = obj.imagedata(:,shuffledOrder(1:N));
		end

        
    end % methods
    
end % classdef

