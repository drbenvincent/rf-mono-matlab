function [y]=optimise_outputs(net,x)
% This function calculates the optimal output values. This optimum
% minimises the reconstruction error with the lowest firing rate cost.
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


lr			=net.lr;
W			=net.w;
y  			=W*x;

% create K. A vector of learning rates for each input image
%K=5*var(x)'.*ones(net.batch_size,1)/0.001;
K=ones(net.batch_size,1)*0.2;
n=1;
diff=inf;
% Define the ses of outputs that we want to update. As each converges, we
% can remove them from the set to increase speed.
SET=ones(net.batch_size,1);
	
for n=1:20

	r			=W'*y;			% reconstruction
	error		=x-r;			% residual error
	
	% Measure things
	e(:,n)	=sum(error.^2)';
	c(:,n)	=sum(abs(y))' * net.RATE_COST;
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
	A=(ones(net.numhid,1)*K(SET==1)');
	B=net.RATE_COST;
	
	y(:,SET==1)=y(:,SET==1)+A.*(W*error(:,SET==1) - B*sign(y(:,SET==1)));	
	% ===================================================================

	y_new=y;
	
	diff=sum(sum((y_old-y_new).^2));
	
	% decrease lr (K) over time
	K=K*0.95;
	
end

return