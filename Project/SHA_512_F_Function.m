function [Hnew] = SHA_512_F_Function(Hprev,M)
WValues = SHA_512_W_Function(M);
HashKValues = load('HashKValues.mat').HashKValues;
for i=1:80
    temp1 = mod(circshift(Hprev(1,:),28,2)+circshift(Hprev(1,:),34,2)+circshift(Hprev(1,:),39,2),2);
    temp2 = mod(circshift(Hprev(5,:),14,2)+circshift(Hprev(5,:),18,2)+circshift(Hprev(5,:),41,2),2);
    T1 = Addition_Module_2_power_64([Hprev(8,:);Ch(Hprev(5,:),Hprev(6,:),Hprev(7,:));temp2;WValues(i,:);HashKValues(i,:)]);
    T2 = Addition_Module_2_power_64([temp1;Maj(Hprev(1,:),Hprev(2,:),Hprev(3,:))]);
    Hnew = circshift(Hprev,1,1);
    Hnew(1,:) = Addition_Module_2_power_64([T1;T2]);
    Hnew(5,:) = Addition_Module_2_power_64([Hprev(4,:);T1]);
    Hprev = Hnew;
    binaryVectorToHex(Hnew);
end
end
%%
function [Output] = Ch(Input1,Input2,Input3)
Output = mod(and(Input1,Input2)+and(~Input1,Input3),2);
end
%%
function [Output] = Maj(Input1,Input2,Input3)
Output = mod(and(Input1,Input2)+and(Input1,Input3)+and(Input2,Input3),2);
end