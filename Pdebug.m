clc
clear

satID = 8;

X1A_init = logical([0 0 1 0 0 1 0 0 1 0 0 0]);
X1B_init = logical([0 1 0 1 0 1 0 1 0 1 0 0]);
X2A_init = logical([1 0 0 1 0 0 1 0 0 1 0 1]);
X2B_init = logical([0 1 0 1 0 1 0 1 0 1 0 0]);



register = X1A_init;
for i = 1:4092
    %Сдвиговый регистр X1A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X1A(i)      = register(end);
    register    = circshift(register,1);
    register(1) = xor(register(6),xor(register(8),xor(register(11),register(12))));
end


X1 = xor(X1A(1:12),X1B_init);
X2i = circshift(xor(X2A_init,X2B_init),satID);
X2i(1:satID) = X2i(satID+1); 

P = xor(X1,X2i);


pdec = bin2dec(num2str(P))