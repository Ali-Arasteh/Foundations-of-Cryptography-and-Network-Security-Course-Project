function [OutputColumn] = AES_MixColumns(InputColumn)
OutputColumn = zeros(8,4);
A = hexToBinaryVector(['02';'03';'01';'01'],8)';
for i = 1:4
    for j = 1:4
        temp = Calculator(A(:,j)',InputColumn(:,j)','*');
        OutputColumn(:,i) = Calculator(OutputColumn(:,i)',temp,'+')'; 
    end
    A = circshift(A,1,2);
end
end