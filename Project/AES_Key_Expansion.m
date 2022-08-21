function [ExpandedKey] = AES_Key_Expansion(Key)
SBox = load('SBox.mat').SBox;
ExpandedKey = zeros(8,4,44);
for j=1:4
    for i=1:4
        ExpandedKey(:,i,j) = Key((j-1)*32+(i-1)*8+1:(j-1)*32+i*8);
    end
end
RC = hexToBinaryVector(['01';'02';'04';'08';'10';'20';'40';'80';'1B';'36'],8)';
for i=5:44
   temp = ExpandedKey(:,:,i-1);
   if mod(i,4) == 1
       temp = circshift(temp,3,2);
       for j=1:4
           temp(:,j) = SBox(:,bi2de(flip(temp(1:4,j))')+1,bi2de(flip(temp(5:8,j))')+1);
       end
       temp(:,1) = mod(temp(:,1)+RC(:,(i-1)/4),2);
   end
   ExpandedKey(:,:,i) = mod(ExpandedKey(:,:,i-4)+temp,2);
end
end