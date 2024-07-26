function Selected_index = ModelSelect(rank_change, num)
   
    M = size(rank_change, 2);
    Selected_index =  cell(1, M);
    
    for i = 1 : M
        [~, index] = sort(rank_change(:, i), 'ascend');
        Selected_index{1, i} = index(1:num, :);
    end

end