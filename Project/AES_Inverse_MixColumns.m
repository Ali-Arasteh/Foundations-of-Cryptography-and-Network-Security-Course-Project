function [OutputColumn] = AES_Inverse_MixColumns(InputColumn)
OutputColumn = zeros(8,4);
A = hexToBinaryVector(['0E';'0B';'0D';'09'],8)';
for i = 1:4
    for j = 1:4
        temp = Calculator(A(:,j)',InputColumn(:,j)','*');
        OutputColumn(:,i) = Calculator(OutputColumn(:,i)',temp,'+')'; 
    end
    A = circshift(A,1,2);
end
end