function [net,IMAGES]=learn(net,IMAGES)
% Runs an iteration of the learning algorithm
%
% NOTE: we offload some of the structure into individual matricies because
% it can speed up calculation slightly.
%
%
%
% =============== THIS CODE WAS WRITTEN BY BENJAMIN VINCENT ===============
% IF YOU DO ANYTHING COOL WITH THIS CODE, FEEL FREE TO EMAIL ME AT:
% B.T.VINCENT@DUNDEE.AC.UK
%
% IF YOU USE IT, PLEASE CITE THE FOLLOWING WORK:
%
% - Vincent B, Troscianko T, Gilchrist I, (2007) Investigating a
% space-variant weighted salience account of visual selection,
% Vision Research, 47(13): 1809-1820.
%
% - Vincent B, Baddeley R, Troscianko T, Gilchrist I, (2005) Is the early
% visual system optimised to be energy efficient, Network: Computation in 
% Neural Systems, 16(2/3): 175-190.
% =========================================================================

if net.batch_size < size(IMAGES,2)
	% use a random subset of images
	bit			= ceil(rand(net.batch_size,1)*size(IMAGES,2));
	x           = IMAGES(:,bit);
else
	%use ALL images
	x=IMAGES;
end

LR		= net.lr;
W		= net.w;

% Calculate optimal outputs
y		= optimise_outputs(net,x);

% LMS rule for autoassociator, equal to Oja's rule ==============
% The next bit calculates it but I've expanded it to calculate it
% faster : dw=( (x'-net.w*y')*y );
r		= W'*y; 
e		= x-r;
dw		= y*e';
% also do bit for synaptic cost
if net.SYNAPSE_COST~=0
	dw	= dw - ( net.SYNAPSE_COST * sign(W) );
end

dw		= dw*LR;
%dw		= dw*LR*(1/net.batch_size);
% ===============================================================


% Update weights ====
W 		= W+dw;
net.w	= W;
% ===================

% Set L2 of each filter to 1
[net]=set_l2_to_1(net);


% ===============================================================
net.epoch			=net.epoch + 1;
net.lr_schedule		=net.lr_schedule + 1;

if rem(net.epoch,net.display_interval)==0
	% PLOT FILTERS
	figure(1), clf
	see_matrix(net.w);

	figure(2),clf,colormap(gray)
	subplot(2,1,1)
	hist(net.w(:),200)
	title('synapse strength distribution')
	subplot(2,1,2)
	hist(y(:),200)
	title('firing rate distribution')

	drawnow

	fprintf('%5.0f\n',net.epoch);
end

% Learning rate schedule
if net.lr_schedule > 100000
	net.lr=net.lr*0.75;
	fprintf('Scheduled LR decrease to %f\n',net.lr)
	net.lr_schedule=0;
end



return