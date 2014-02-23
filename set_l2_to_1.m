function [net]=set_L2_to_1(net)

% SET L2 OF EACH FILTER TO 1
l2=sum(net.w'.^2);
for n=1:net.numhid
	net.w(n,:)=net.w(n,:) * abs(1/sqrt(l2(n)));
end

return