function [] = AES_S_Box()
A = zeros(8,8);
temp = [1 0 0 0 1 1 1 1];
for i=1:8
    A(i,:) = circshift(temp,i-1);
end
B = [1 1 0 0 0 1 1 0]';
One = [0 0 0 0 0 0 0 1];
SBox = zeros(8,16,16);
for i=1:16
    for j=1:16
        RowColumnBinaryVector = [decimalToBinaryVector(i-1,4),decimalToBinaryVector(j-1,4)];
        InvInGF = Calculator(One,RowColumnBinaryVector,'/')';
        SBox(:,i,j) = flip(mod(A*flip(InvInGF) + B,2))';
    end
end
save('SBox.mat', 'SBox');
end