function b = pam2bits(m,gray)

if nargin==1, gray=0; end

if gray==0,
    aux1 = (m+3)/2;
    aux2 = [floor(aux1/2); mod(aux1,2)];
else
    aux2 = [(1+sign(m))/2 ; (3-abs(m))/2];
end
b = reshape(aux2, prod(size(aux2)), 1);
