function [big]=see_matrix(x)
% Plots the receptive fields
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




[count, m]	=size(x);
m=sqrt(m);
% reshape into a 12x12x64 matric, for example
x=reshape(x',[m m count]);
% number of rows and cols of receptive fields to plot
mm=ceil(sqrt(count));
% preallocate empty montage matrix
M=zeros(mm*m, mm*m);
im=1;

for j=0:mm-1
	for k=0:mm-1
		% break if all receptive fields are plotted
		if im>count
			break
		end
		sliceM=j*m;
		sliceN=k*m;
		M(sliceN+1:sliceN+m, sliceM+1:sliceM+m) = x(:,:,im);
		im=im+1;
	end
end


%figure(1)
%clf
colormap(gray)
imagesc(M)
axis square
axis off

return