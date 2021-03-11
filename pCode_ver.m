clc
clear

% �������� ������ 
PRN = 25;
day = 6;

code = pCode_v3(PRN,(day-1)*86400);    % ��������� ����� ����� ����

code = code(1:256);                    % ��������� ������ 256 ���������
str = erase(num2str(code),' ');        % �������� �������� �� ������ 

hexPcode = bin2hex(str)                % ������� �� bin � hex (! bin2hex - ��������� �������, �� ����������!)

reference = referencePCode(PRN,day)

% ������ ������ ����� ���� � �������� 
hexPcode_equals_reference = isequal(reference,hexPcode)
