function [sdec, snum] = DivisionSearchDomain(dec, D)
    snum = randperm(size(dec, 2), D);
    sdec = dec(:, snum);

end