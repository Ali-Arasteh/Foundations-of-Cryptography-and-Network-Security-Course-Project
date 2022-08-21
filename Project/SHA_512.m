function [Output,Status] = SHA_512(Input)
if length(Input) < 2^128
    L = length(Input);
    if mod(L+1,1024) <= 896
        Count = 896 - mod(L+1,1024);
    else
        Count = 1920 - mod(L+1,1024);
    end
    PaddedInput = [Input 1 zeros(1,Count) flip(de2bi(L,128))];
    if ~isfile('InitialHashBuffer.mat')
        SHA_512_Initial_Hash_Buffer();
    end
    InitialHashBuffer = load('InitialHashBuffer.mat').InitialHashBuffer;
    if ~isfile('HashKValues.mat')
        SHA_512_Hash_K_values();
    end
    Hi = SHA_512_F_Function(InitialHashBuffer,PaddedInput(1,1:1024));
    for i=1:8
        Hi(i,:) = Addition_Module_2_power_64([InitialHashBuffer(i,:);Hi(i,:)]);
    end
    for l=1:length(PaddedInput)/1024-1
        temp = SHA_512_F_Function(Hi,PaddedInput(1,l*1024+1:(l+1)*1024));
        for i=1:8
            Hi(i,:) = Addition_Module_2_power_64([Hi(i,:);temp(i,:)]);
        end
    end
    Output = zeros(1,512);
    for i=1:8
        Output(1,(i-1)*64+1:i*64) = Hi(i,:);
    end
    Status = "Successful";
else
    Output = zeros(1,512);
    Status = "Length of Input must be less than 2 ^ 128";
end
end