function off = OffspringComplement(offdec, popdec, indx)
    off = zeros(size(popdec,1), size(popdec, 2));
    for i = 1 : size(popdec, 2)
        if ismember(i, indx)
            [~, loc] = ismember(i, indx);
            off(:, i) = offdec(:, loc);
        else
            off(:, i) = offdec(:, randperm(size(offdec,2),1));
        end
    end
end