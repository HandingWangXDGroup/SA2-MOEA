function num = ModelPoolCensus(model_pool, pool_size)
    Flag = 0;
    for i = 1 : pool_size
       if  isempty(model_pool{i, 1})
           num = i - 1; Flag = 1;
           break;     
       end
    end
    if i == pool_size && Flag == 0
        num = pool_size;
    end
end