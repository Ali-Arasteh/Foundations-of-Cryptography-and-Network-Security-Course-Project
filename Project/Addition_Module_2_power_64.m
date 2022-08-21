function [Output] = Addition_Module_2_power_64(Input)
Output = Input(1,:);
L = size(Input,1);
if L > 1
    for i=2:L
        Carry = 0;
        for j=1:64
            temp = mod(Output(1,65-j)+Input(i,65-j)+Carry,2);
            Carry = mod(and(Output(1,65-j),Input(i,65-j))+and(Output(1,65-j),Carry)+and(Input(i,65-j),Carry),2);
            Output(1,65-j) = temp;
        end
    end
end
end