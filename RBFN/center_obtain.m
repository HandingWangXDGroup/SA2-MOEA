function centers=center_obtain(Popdec,center_num)
    
    if size(Popdec, 1) >= center_num
        [~,centers]=kmeans(Popdec,center_num);
    else
        [~,centers1]=kmeans(Popdec,size(Popdec, 1));
        num_remain = center_num - size(Popdec, 1);
        idx = nchoosek(1:size(Popdec, 1),2);
        rs = randperm(size(idx, 1), num_remain);
        sidx = idx(rs', :);
       for i = 1 : num_remain
           centers2(i, :) = (Popdec(sidx(i, 1), :) + Popdec(sidx(i, 1), :))/2;
       end
       centers = [centers1; centers2];
    end
end