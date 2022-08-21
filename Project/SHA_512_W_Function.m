function [WValues] = SHA_512_W_Function(M)
WValues = zeros(80,64);
for i=1:16
    WValues(i,:) = M((i-1)*64+1:i*64);
end
for i=17:80
    temp1 = mod(circshift(WValues(i-2,:),19,2)+circshift(WValues(i-2,:),61,2)+SHR(WValues(i-2,:),6),2);
    temp2 = mod(circshift(WValues(i-15,:),1,2)+circshift(WValues(i-15,:),8,2)+SHR(WValues(i-15,:),7),2);
    WValues(i,:) = Addition_Module_2_power_64([temp1;WValues(i-7,:);temp2;WValues(i-16,:)]);
end
end
%%
function [Output] = SHR(Input,N)
L = length(Input);
Output = zeros(1,L);
if (0 <= N) && (N < L)
   Output(N+1:end) = Input(1:end-N);
end
end