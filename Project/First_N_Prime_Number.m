function [FirstNPrimeNumber] = First_N_Prime_Number(N)
if N > 0
    FirstNPrimeNumber = zeros(1,N);
    Counter = 0;
    i = 1;
    while Counter < N
        if isprime(i)
            Counter = Counter + 1;
            FirstNPrimeNumber(Counter) = i;
        end
        i = i + 1;
    end
else
    FirstNPrimeNumber = [];
end
end