function decArray = ArrrayNormalization(dec, miner, maxer)
    L = size(dec, 2);
    N = size(dec, 1);
    decArray = zeros(N, L);
    for i = 1 : L
        k = (1/(maxer(i) - miner(i)));
        for j = 1 : N
            decArray(j, i) = k*(dec(j, i) - miner(i));
        end
    end

end