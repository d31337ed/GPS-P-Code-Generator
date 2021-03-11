clc
clear

% Исходные данные 
PRN = 25;
day = 6;

code = pCode_v3(PRN,(day-1)*86400);    % Генерация одной эпохи кода

code = code(1:256);                    % Выделение первых 256 элементов
str = erase(num2str(code),' ');        % Удаление пробелов из строки 

hexPcode = bin2hex(str)                % Перевод из bin в hex (! bin2hex - сторонняя функция, не встроенная!)

reference = referencePCode(PRN,day)

% Сверка первых чипов кода с эталоном 
hexPcode_equals_reference = isequal(reference,hexPcode)
