function [] = AES_Inverse_S_Box()
A = zeros(8,8);
temp = [0 0 1 0 0 1 0 1];
for i=1:8
    A(i,:) = circshift(temp,i-1);
end
B = [1 0 1 0 0 0 0 0]';
One = [0 0 0 0 0 0 0 1];
InverseSBox = zeros(8,16,16);
for i=1:16
    for j=1:16
        RowColumnBinaryVector = [decimalToBinaryVector(i-1,4),decimalToBinaryVector(j-1,4)]';
        InvInGFInput = flip(mod(A*flip(RowColumnBinaryVector) + B,2))';
        InverseSBox(:,i,j) = Calculator(One,InvInGFInput,'/');
    end
end
save('InverseSBox.mat', 'InverseSBox');
end