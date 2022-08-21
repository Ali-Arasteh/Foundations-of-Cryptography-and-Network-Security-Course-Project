function [PlainText] = AES_Decryption(CipherText,Key)
if ~isfile('SBox.mat')
    AES_S_Box();
end
if ~isfile('InverseSBox.mat')
    AES_Inverse_S_Box();
end
InverseSBox = load('InverseSBox.mat').InverseSBox;
ExpandedKey = AES_Key_Expansion(Key);
L = length(CipherText);
for l=1:L/128
    StateMatrix = zeros(8,4,4);
    for j=1:4
        for i=1:4
            StateMatrix(:,i,j) = CipherText((l-1)*128+(j-1)*32+(i-1)*8+1:(l-1)*128+(j-1)*32+i*8);
        end
    end
    StateMatrix = mod(StateMatrix+ExpandedKey(:,:,41:44),2);
    for i=1:9
        for j=1:4
            StateMatrix(:,j,:) = circshift(StateMatrix(:,j,:),j-1,3);
        end
        for j=1:4
            for k=1:4
                StateMatrix(:,j,k) = InverseSBox(:,bi2de(flip(StateMatrix(1:4,j,k))')+1,bi2de(flip(StateMatrix(5:8,j,k))')+1);
            end
        end
        StateMatrix = mod(StateMatrix+ExpandedKey(:,:,(10-i)*4+1:(10-i)*4+4),2);
        for j=1:4
            StateMatrix(:,:,j) = AES_Inverse_MixColumns(StateMatrix(:,:,j));
        end
    end
    for j=1:4
        StateMatrix(:,j,:) = circshift(StateMatrix(:,j,:),j-1,3);
    end
    for j=1:4
        for k=1:4
            StateMatrix(:,j,k) = InverseSBox(:,bi2de(flip(StateMatrix(1:4,j,k))')+1,bi2de(flip(StateMatrix(5:8,j,k))')+1);
        end
    end
    StateMatrix = mod(StateMatrix+ExpandedKey(:,:,1:4),2);
    for j=1:4
        for i=1:4
            PlainText(1,(l-1)*128+(j-1)*32+(i-1)*8+1:(l-1)*128+(j-1)*32+i*8) = StateMatrix(:,i,j);
        end
    end
end
PlainText = PlainText(1,1:bi2de(flip(PlainText(1,end-127:end))));
end