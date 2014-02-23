function [a,b]=max_abs(input)
% This function finds the value in the 'input' vector with the highest
% magnitude
%
% a		gives the value
% b		indexed the position of the value
%
% [a b]=max_abs(input);


mmax=abs(max(input));
mmin=abs(min(input));

[a b]	=max(abs(input));

if mmax<mmin
	a=-a;
end

return