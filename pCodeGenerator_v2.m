%function [pcode] = pCodeGenerator(satID,start,duration)
clc
clear
time = 0;
duration = 1;
satID = 10;
%%Инициализация регистров X-кода
X1A_init = logical([0 0 1 0 0 1 0 0 1 0 0 0]);
X1B_init = logical([0 1 0 1 0 1 0 1 0 1 0 0]);
X2A_init = logical([1 0 0 1 0 0 1 0 0 1 0 1]);
X2B_init = logical([0 1 0 1 0 1 0 1 0 1 0 0]);
%%
%Вычисление знчаения регистров в заданный момент времени
currentEpoch = floor(time/1.5)+1;                 %Вычисление номера текущей эпохи 
X2shift = rem(15345037,currentEpoch*37);        %Суммарный сдвиг (в чипах) X2 относительно X1

%%

X1A(1:11) = X1A_init(1:11);
register = X1A_init;
for i = 1:4092
    %Сдвиговый регистр X1A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X1A(i)   = xor(register(6),xor(register(8),xor(register(11),register(12))));
    register(1) = X1A(i) ;
    register = circshift(register,1);
end

X1B(1:11) = X1B_init(1:11);
register = X1B_init;
for i = 1:4093
    %Сдвиговый регистр X2A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X1B(i)   = xor(register(1),xor(register(2),xor(register(5),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))));
    register(1) = X1B(i) ;
    register = circshift(register,1);
end
X1A_epoch = repmat(X1A,[1 3750]);
X1B_epoch = repmat(X1B,[1 3750]);
%В последнем такте эпохи регистр X1B удерживается в последнем состоянии предыдущего такта
X1B_epoch(15340909:end) = X1B_epoch(15340908);
X1B_epoch(15345001:end) = [];
X1_epoch  = xor(X1A_epoch,X1B_epoch);

%%

X2A(1:11) = X2A_init(1:11);
register  = X2A_init;
for i = 1:4092
    %Сдвиговый регистр X2A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X2A(i) = xor(register(1),xor(register(3),xor(register(4),xor(register(5),xor(register(7),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))))));
    register(1) = X2A(i) ;
    register = circshift(register,1);
end

X2B(1:11) = X2B_init(1:11);
register  = X2B_init;
for i = 1:4092
    %Сдвиговый регистр X2A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X2B(i)   = xor(register(2),xor(register(3),xor(register(4),xor(register(8),xor(register(9),register(12))))));
    register(1) = X2B(i) ;
    register = circshift(register,1);
end

X2A_epoch = repmat(X2A, [1,3750]);
X2A_epoch(15345001:15345037) = X2A_epoch(1534500);
X2B_epoch = repmat(X2B, [1,3751]);
X2B_epoch(15340909:end) = X2B_epoch(15340908);
X2B_epoch(15345038:end) = [];
X2_epoch = xor(X2A_epoch,X2B_epoch);
X2i = circshift(X2_epoch,satID);
X2i(1:satID) = X2i(satID+1);

P_epoch = xor(X1_epoch,X2i(1:15345000));
pbin = P_epoch(1:12)
pdec = bin2dec(num2str(P_epoch(1:12)))
%%
% deltaT = time + 1.5- 1.5*currentEpoch;                     %Разница между заданным временем и началом текущей эпохи X1
% numOfEpochs = ceil((deltaT + duration)/1.5);               %Целое число эпох в запрашиваемом участке времени (оценка сверху)
% X1_pack = repmat(X1_epoch,1,numOfEpochs);
% X2_shifted = circshift(X2_epoch,X2shift+satID);
% X2_pack = repmat(X2_shifted,1,numOfEpochs);
% %Pcode = xor( X1_pack(deltaT*1.023e7+1:(deltaT+duration)*1.023e7+1),X2_pack(deltaT*1.023e7+1:(deltaT+duration)*1.023e7+1) );
% 
% Pcode = xor(X1_pack(1:(deltaT+duration)*1.023e7+1),X2_pack(1:(deltaT+duration)*1.023e7+1) );

%end