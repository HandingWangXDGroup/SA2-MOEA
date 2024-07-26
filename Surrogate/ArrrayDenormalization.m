function decArray = ArrrayDenormalization(dec, miner, maxer)

    L = size(dec, 2);
    N = size(dec, 1);
    decArray = zeros(N, L);
    for i = 1 : L
        k = maxer(i) - miner(i);
        for j = 1 : N
            decArray(j, i) = k*dec(j, i) + miner(i);
        end
    end

end