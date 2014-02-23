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

x=x';

[a b]	=size(x);

for n=1:b
	m		= max_abs(x(:,n));
	x(:,n)	= x(:,n)*(1/m);
end

biggest=1;

if rem(b,sqrt(b))==0
    % then good amount of filters
else
    % bad amount of filters
    d	=ceil(sqrt(b)).^2;   % desired amount of filters
	x([1:a],[b:d])=-biggest;
    b	=d;
end

c	=round(sqrt(a));
d	=round(sqrt(b));

ws	=zeros(c,c,b);
ws	=reshape(x,c,c,b);

z	=2+d-1;
big	=ones(c*d+z,c*d+z);
big	=big*-biggest;
n	=1;
xa	=0;
ya	=0;
for s=0:d-1
    for t=0:d-1
        big([s*c+2+s:s*c+c+1+s],[t*c+2+t:t*c+c+1+t])=-ws(:,:,n);
        n=n+1;
        ya=ya+1;
    end
    xa=xa+1;
end

figure(1)
clf
colormap(gray)

imagesc(big)

axis square
axis off


return