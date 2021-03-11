function [pcode] = pCode_sb(satID,startTime)
% ������� ���������� P-��� ������� GPS ��� ��������� ��, ������� � ��������
% ������� ������ GPS � �������� ������������. ��������� �������:
% satID     - PRN �������� GPS
% startTime - ������� ������ GPS, ������� � ������� ����� �������������� ��� (���� ������ ������� 1.5)
% � ���������� �����������:
% 1) ����� � ������� ����������� �������� ��� � ������ ������� �������
% 2) �������� ����������� ��������� ���� ������� 1 �����


fd = 10.23e6;                                                        % ������� �������������
duration = 1.5;                                                      % ���� ����� ������������ ������ ���� �����

% ����� ������� �����
currentEpoch = floor(startTime/1.5)+1;                               % ���������� ������ ������� �����  

% ��������� ������������������ X1A
register = logical([0 0 0 1 0 0 1 0 0 1 0 0]);                    
for i = 1:4092
    %��������� ������� X1A: ��������� ������ �������� ����������� ��������� � ����� ��������
    X1A(i)      = register(end);
    newFirst    = xor(register(6),xor(register(8),xor(register(11),register(12))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X1A_epoch = repmat(X1A,1,3750);

% ��������� ������������������ X1B
register = logical([0 0 1 0 1 0 1 0 1 0 1 0]); 
for i = 1:4093
    %��������� ������� X1B: ��������� ������ �������� ����������� ��������� � ����� ��������
    X1B(i)      = register(end);
    newFirst    = xor(register(1),xor(register(2),xor(register(5),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X1B_epoch = [repmat(X1B,1,3749) ones(1,343)];   % �� 343 ���� �� ����� �����, X1B ������������ � ��������� ��������� 

% ��������� ������������������ X2A
register =  logical([1 0 1 0 0 1 0 0 1 0 0 1]); 
for i = 1:4092
    %��������� ������� X1A: ��������� ������ �������� ����������� ��������� � ����� ��������
    X2A(i)      = register(end);
    newFirst    = xor(register(1),xor(register(3),xor(register(4),xor(register(5),xor(register(7),xor(register(8),xor(register(9),xor(register(10),xor(register(11),register(12))))))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X2A_epoch = [repmat(X2A,1,3750) ones(1,37)];

% ��������� ������������������ X2B
register = logical([0 0 1 0 1 0 1 0 1 0 1 0]); 
for i = 1:4093
    %��������� ������� X1A: ��������� ������ �������� ����������� ��������� � ����� ��������
    X2B(i)      = register(end);
    newFirst    = xor(register(2),xor(register(3),xor(register(4),xor(register(8),xor(register(9),register(12))))));
    register    = circshift(register,1);
    register(1) = newFirst;
end
X2B_epoch = [repmat(X2B,1,3749) zeros(1,343)];  % �� 343 ���� �� ����� �����, X2B ������������ � ��������� ��������� 

X1 = xor(X1A_epoch,X1B_epoch);   % ��������� ����� ����� ������������������ X1
X2 = xor(X2A_epoch,X2B_epoch);   % ��������� ����� ����� ������������������ X2

% ������������ X2i ��� ����������� PRN

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

% !!��� ��� �������, ���� ����� ��� ��������. ������-�� ��� ������ �����
% ������ ����� ������ �������� X2 ������������ X1. ������ �����, ��� ����
% ������ � ������ ����������� ������ ������� ����� (��. ������ 15)
if currentEpoch==1
    X2i = circshift(X2i,37*(currentEpoch-1));
else
    X2i = circshift(X2i,37*(currentEpoch-0));
end

X1Pack = repmat(X1,1,ceil(duration/1.5));   % "�����" X1 ��������� ������������                     
X2Pack = repmat(X2i,1,ceil(duration/1.5));  % "�����" X2 ��������� ������������
X2Pack = X2Pack(1:length(X1Pack));          % ���������� ������ ����� X2 � ����� �1

pcode = xor(X1Pack,X2Pack);
end