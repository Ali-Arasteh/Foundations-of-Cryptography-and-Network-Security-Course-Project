function [] = SHA_512_Hash_K_values()
HashKValues = zeros(80,64);
First80PrimeNumber = First_N_Prime_Number(80)';
for i=1:80
    A = First80PrimeNumber(i)^vpa(1/3) - floor(First80PrimeNumber(i)^vpa(1/3));
    for j=1:64
        if A >= 2^(-j)
            A = A - 2^(-j);
            HashKValues(i,j) = 1;
        end    
    end
end
save('HashKValues.mat', 'HashKValues');
end