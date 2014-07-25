classdef network < handle
	%% NETWORK An autoassociator neural network object
	% Detailed exlanation here
	% Making this a handle class means it can change it's own properties
	% without having to return values back to the command window.
	
	% public properties
	properties
		display_interval
		lr
	end
	
	% read-only properties
	properties(GetAccess='public', SetAccess='private')
		synapse_cost
		firing_rate_cost
		
		numin
		numhid
		w
		batchSize
		batchesDone
	end
	
	% protected, i.e. not visible from outside
	properties(Access = protected)
	end
	
	methods
		
		% Class constructor
		function obj=network(num_neurons,synapse_cost,firing_rate_cost, numin)
			% intialise with parameters
			obj.numhid				= num_neurons;
			obj.synapse_cost		= synapse_cost;
			obj.firing_rate_cost	= firing_rate_cost;
			obj.numin				= numin;
			% initialise with some defaults
			obj.lr					= 0.8; % default
			obj.batchesDone			= 0;
			obj.batchSize			= 100;
			obj.display_interval	= 1000;
			% create random weights
			obj.w =randn(obj.numhid, obj.numin)*0.1;
			display('network object created')
		end
		
		function plot_receptive_fields(obj)
			m=sqrt(obj.numin);
			% reshape weights into a 12x12x64 matric, for example
			x=reshape(obj.w',[m m obj.numhid]);
			% number of rows and cols of receptive fields to plot
			mm=ceil(sqrt(obj.numhid));
			% preallocate empty montage matrix
			M=zeros(mm*m, mm*m);
			im=1;
			
			for j=0:mm-1
				for k=0:mm-1
					% break if all receptive fields are plotted
					if im>obj.numhid
						break
					end
					sliceM=j*m;
					sliceN=k*m;
					M(sliceN+1:sliceN+m, sliceM+1:sliceM+m) = x(:,:,im);
					im=im+1;
				end
			end
			
			figure(1)
			clf
			colormap(gray)
			imagesc(M)
			axis square
			axis off
			drawnow
		end
		
		
		function learn(obj, dataset)
			% Learn with Mini Batch Gradient Descent
			
			% give me images
			x =dataset.giveMeSomeRandomImages(obj.batchSize);
			
			% calculate outputs
			y = optimise_outputs(obj,x);
			
			% calculate weight update direction
			r		= obj.w'*y;
			e		= x-r;
			dw		= y*e';
			% also do bit for synaptic cost
			if obj.synapse_cost>0
				dw	= dw - ( obj.synapse_cost * sign(obj.w) );
			end
			
			% apply fixed learning rate
			alpha	= obj.lr*(1/obj.batchSize);
			dw		= dw*alpha;
			
			% apply weight update
			obj.w	= obj.w+dw;
			
			% set L2 norm of each filter to 1
			[obj.w]=set_L2_to_1(obj.w);
			
			% increment counter
			obj.batchesDone = obj.batchesDone + 1;
			
			% plot?
			if rem(obj.batchesDone, obj.display_interval)==0
				fprintf('%d\n',obj.batchesDone);
				obj.plot_receptive_fields()
			end
		end
		
	end % methods
	
end % classdef







%% Private functions 





function [w]=set_L2_to_1(w)
l2=sum(w'.^2); % calcualte current L2 norm
for n=1:size(w,1)
	w(n,:)=w(n,:) * abs(1/sqrt(l2(n)));
end
end






function [y]=optimise_outputs(obj,x)
% This function calculates the optimal output values. This optimum
% minimises the reconstruction error with the lowest firing rate cost.

y  			=obj.w * x;

% create K. A vector of learning rates for each input image
%K=5*var(x)'.*ones(net.batch_size,1)/0.001;
K=ones(obj.batchSize,1)*0.2;
n=1;
diff=inf;
% Define the ses of outputs that we want to update. As each converges, we
% can remove them from the set to increase speed.
SET=ones(obj.batchSize,1);

for n=1:20
	
	r			=obj.w'*y;			% reconstruction
	error		=x-r;			% residual error
	
	% Measure things
	e(:,n)	=sum(error.^2)';
	c(:,n)	=sum(abs(y))' * obj.firing_rate_cost;
	t(:,n)	=e(:,n)+c(:,n);
	y_old=y;
	
	% see if any total errors have increased
	if n>1
		% find total error increases
		INCREASE=t(:,n-1)<t(:,n);
		
		% Restore previous outputs
		y(:,INCREASE)=y_old(:,INCREASE);
		
		% half learning rate
		K(INCREASE)=K(INCREASE)/2;
		
		% REMOVE FROM UPDATE
		%SET(INCREASE)=0;
	end
	
	% NOW DO WEIGHT UPDATE ==============================================
	% y=y+ A[ W*error - B sgn(y) ]
	A=(ones(obj.numhid,1)*K(SET==1)');
	B=obj.firing_rate_cost;
	
	y(:,SET==1)=y(:,SET==1)+A.*(obj.w*error(:,SET==1) - B*sign(y(:,SET==1)));
	% ===================================================================
	
	%y_new=y;
	%diff=sum(sum((y_old-y_new).^2));
	
	% decrease lr (K) over time
	K=K*0.95;
	
end

end

