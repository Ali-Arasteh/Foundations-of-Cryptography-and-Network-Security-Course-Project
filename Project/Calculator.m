function [Output, Status] = Calculator(A,B,Operation)
M = [0 0 0 1 1 0 1 1];
Status = "Successful";
if(Operation == '+' || Operation == '-')
    Output = xor(A,B);
elseif(Operation == '*')
    Output = [0 0 0 0 0 0 0 0];
    A_Multiples = zeros(8,8);
    for i = 1:8
       if(i == 1)
           A_Multiples(i,:) = A;
       else
           A_Multiples(i,:) = [A_Multiples(i-1,2:8),0];
           if(A_Multiples(i-1,1) == 1)
               A_Multiples(i,:) = Calculator(A_Multiples(i,:),M,'+');
           end
       end
    end
    for i = 0:7
        if(B(8-i) == 1)
            Output = Calculator(Output,A_Multiples(i+1,:),'+');
        end
    end
elseif(Operation == '/')
    if(find(B == 1,1) == 8)
        Output = A;
    else
        V_2 = [0 0 0 0 0 0 0 1];
        W_2 = [0 0 0 0 0 0 0 0];
        V_1 = [0 0 0 0 0 0 0 0];
        W_1 = [0 0 0 0 0 0 0 1];
        Q = [0 0 0 0 0 0 0 0];
        t1 = 8;
        tB1 = find(B == 1,1);
        t2 = 8 - tB1;
        tB = zeros(1,8);
        Q(8 - (t1 - t2)) = 1;
        tB(1:8 - (t1 - t2)) = B(find(B == 1,1) + 1:8);
        tM = Calculator(M,tB,'+');
        tM1 = find(tM == 1,1);
        t1 = 8 - tM1;
        while(t1 >= t2)
            Q(8 - (t1 - t2)) = 1;
            tB = zeros(1,8);
            tB(tM1:tM1 + t2) = B(tB1:8);
            tM = Calculator(tM,tB,'+');
            tM1 = find(tM == 1,1);
            t1 = 8 - tM1;
        end
        R = tM;
        tV = Calculator(V_2,Calculator(Q,V_1,'*'),'-');
        tW = Calculator(W_2,Calculator(Q,W_1,'*'),'-');
        V_2 = V_1;
        W_2 = W_1;
        V_1 = tV;
        W_1 = tW;
        while(sum(R) ~= 0)
            tM = B;
            B = R;
            Q = [0 0 0 0 0 0 0 0];
            R = [0 0 0 0 0 0 0 0];
            tM1 = find(tM == 1,1);
            t1 = 8 - tM1;
            tB1 = find(B == 1,1);
            t2 = 8 - tB1;
            while(t1 >= t2)
                Q(8 - (t1 - t2)) = 1;
                tB = zeros(1,8);
                tB(tM1:tM1 + t2) = B(tB1:8);
                tM = Calculator(tM,tB,'+');
                tM1 = find(tM == 1,1);
                t1 = 8 - tM1;
            end
            R = tM;
            tV = Calculator(V_2,Calculator(Q,V_1,'*'),'-');
            tW = Calculator(W_2,Calculator(Q,W_1,'*'),'-');
            V_2 = V_1;
            W_2 = W_1;
            V_1 = tV;
            W_1 = tW;
        end
        B_Inverse = W_2;
        Output = Calculator(A,B_Inverse,'*');
    end
else
    Output = [0 0 0 0 0 0 0 0];
    Status = "Operation can only be one of the values of +, -, * and /.";
end
end