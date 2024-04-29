function m = bits2pam(b,gray);

if nargin == 1,
    gray = 0;
end

aux1 = reshape(b, 2, length(b)/2);
if gray==0,
    aux2 = 2*aux1(1,:) + aux1(2,:);
    m = 2*aux2 - 3;
else
    m = (2*aux1(1,:)-1).*(3-2*aux1(2,:));
end
