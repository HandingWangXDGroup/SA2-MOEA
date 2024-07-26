function rankDelta = MeasureUncertainty(arf1, arf2)
        lam=size(arf1',2);
        [~,idx] = sort([arf1',arf2']);
        [~,ranks] = sort(idx);
        ranks = reshape(ranks,lam,2)';
        
        rankDelta = (abs(ranks(1,:)-ranks(2,:)-sign(ranks(1,:)-ranks(2,:))))';
end