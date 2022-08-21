function [] = SHA_512_Initial_Hash_Buffer()
InitialHashBuffer = zeros(8,64);
First8PrimeNumber = First_N_Prime_Number(8)';
for i=1:8
    A = First8PrimeNumber(i)^vpa(1/2) - floor(First8PrimeNumber(i)^vpa(1/2));
    for j=1:64
        if A >= 2^(-j)
            A = A - 2^(-j);
            InitialHashBuffer(i,j) = 1;
        end    
    end
end
save('InitialHashBuffer.mat', 'InitialHashBuffer');
end