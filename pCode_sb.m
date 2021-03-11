function [pcode] = pCode_sb(satID,startTime)
% Функция генерирует P-код системы GPS для заданного КА, начиная с заданной
% секунды недели GPS и заданной длительности. Аргументы функции:
% satID     - PRN аппарата GPS
% startTime - Секунда недели GPS, начиная с которой будет генерироваться код (пока только кратная 1.5)
% В дальнейшем планируется:
% 1) Вшить в функцию возможность начинать код с любого момента времени
% 2) Добавить возможность генерации кода длиннее 1 эпохи


fd = 10.23e6;                                                        % Частота дискретизации
duration = 1.5;                                                      % Пока умеем генерировать только одну эпоху

% Номер текущей эпохи
currentEpoch = floor(startTime/1.5)+1;                               % Вычисление номера текущей эпохи  

% Генерация последовательности X1A
register = logical([0 0 0 1 0 0 1 0 0 1 0 0]);                    
for i = 1:4092
    %Сдвиговый регистр X1A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X1A(i)      = register(end);
    newFirst    = xor(register(6),xor(register(8),xor(register(11),register(12))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X1A_epoch = repmat(X1A,1,3750);

% Генерация последовательности X1B
register = logical([0 0 1 0 1 0 1 0 1 0 1 0]); 
for i = 1:4093
    %Сдвиговый регистр X1B: генерация нового элемента порождающим полиномом и сдвиг регистра
    X1B(i)      = register(end);
    newFirst    = xor(register(1),xor(register(2),xor(register(5),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X1B_epoch = [repmat(X1B,1,3749) ones(1,343)];   % За 343 чипа до конца эпохи, X1B удерживается в последнем состоянии 

% Генерация последовательности X2A
register =  logical([1 0 1 0 0 1 0 0 1 0 0 1]); 
for i = 1:4092
    %Сдвиговый регистр X1A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X2A(i)      = register(end);
    newFirst    = xor(register(1),xor(register(3),xor(register(4),xor(register(5),xor(register(7),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X2A_epoch = [repmat(X2A,1,3750) ones(1,37)];

% Генерация последовательности X2B
register = logical([0 0 1 0 1 0 1 0 1 0 1 0]); 
for i = 1:4093
    %Сдвиговый регистр X1A: генерация нового элемента порождающим полиномом и сдвиг регистра
    X2B(i)      = register(end);
    newFirst    = xor(register(2),xor(register(3),xor(register(4),xor(register(8),xor(register(9),register(12))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X2B_epoch = [repmat(X2B,1,3749) zeros(1,343)];  % За 343 чипа до конца эпохи, X2B удерживается в последнем состоянии 

X1 = xor(X1A_epoch,X1B_epoch);   % Генерация одной эпохи последовательности X1
X2 = xor(X2A_epoch,X2B_epoch);   % Генерация одной эпохи последовательности X2

% Формирование X2i для конкретного PRN

if X2(end) == 0
    X2i = circshift([X2 zeros(1,37)], satID);
else
    X2i = circshift([X2  ones(1,37)], satID);
end

if X2(1) == 0
    X2i(1:satID) = zeros(1,satID);
else
    X2i(1:satID) = ones(1,satID);
end

% !!Вот тут костыль, надо будет его обсудить. Почему-то для первой эпохи
% недели нужно другое смещение X2 относительно X1. Скорее всего, его ноги
% растут в кривом определении номера текущей эпохи (см. строку 15)
if currentEpoch==1
    X2i = circshift(X2i,37*(currentEpoch-1));
else
    X2i = circshift(X2i,37*(currentEpoch-0));
end

X1Pack = repmat(X1,1,ceil(duration/1.5));   % "Пакет" X1 требуемой длительности                     
X2Pack = repmat(X2i,1,ceil(duration/1.5));  % "Пакет" X2 требуемой длительности
X2Pack = X2Pack(1:length(X1Pack));          % Приведение пакета кодов X2 к длине Х1

pcode = xor(X1Pack,X2Pack);
end