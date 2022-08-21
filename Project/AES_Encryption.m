function [CipherText] = AES_Encryption(PlainText,Key)
if ~isfile('SBox.mat')
    AES_S_Box();
end
SBox = load('SBox.mat').SBox;
ExpandedKey = AES_Key_Expansion(Key);
L = length(PlainText);
Count = 128 - mod(L,128) - 1;
PaddedPlainText = [PlainText 1 zeros(1,Count) flip(de2bi(L,128))];
CipherText = zeros(1,length(PaddedPlainText));
for l=1:length(PaddedPlainText)/128
    StateMatrix = zeros(8,4,4);
    for j=1:4
        for i=1:4
            StateMatrix(:,i,j) = PaddedPlainText((l-1)*128+(j-1)*32+(i-1)*8+1:(l-1)*128+(j-1)*32+i*8);
        end
    end
    StateMatrix = mod(StateMatrix+ExpandedKey(:,:,1:4),2);
    for i=1:9
        for j=1:4
            for k=1:4
                StateMatrix(:,j,k) = SBox(:,bi2de(flip(StateMatrix(1:4,j,k))')+1,bi2de(flip(StateMatrix(5:8,j,k))')+1);
            end
        end
        for j=1:4
            StateMatrix(:,j,:) = circshift(StateMatrix(:,j,:),5-j,3);
        end
        for j=1:4
            StateMatrix(:,:,j) = AES_MixColumns(StateMatrix(:,:,j));
        end
        StateMatrix = mod(StateMatrix+ExpandedKey(:,:,i*4+1:i*4+4),2);
    end
    for j=1:4
        for k=1:4
            StateMatrix(:,j,k) = SBox(:,bi2de(flip(StateMatrix(1:4,j,k))')+1,bi2de(flip(StateMatrix(5:8,j,k))')+1);
        end
    end
    for j=1:4
        StateMatrix(:,j,:) = circshift(StateMatrix(:,j,:),5-j,3);
    end
    StateMatrix = mod(StateMatrix+ExpandedKey(:,:,41:44),2);
    for j=1:4
        for i=1:4
            CipherText(1,(l-1)*128+(j-1)*32+(i-1)*8+1:(l-1)*128+(j-1)*32+i*8) = StateMatrix(:,i,j);
        end
    end
end
end