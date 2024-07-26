function [Network, model_pool] = ModelIntegrate(Train_A, Test_A, Center_num, model_pool, pool_size, miner, maxer)
    
    Train_Adec = Train_A.decs;
    Train_Aobj = Train_A.objs;
    Train_Adec = ArrrayNormalization(Train_Adec, miner, maxer);
    N = size(Train_Aobj,1);
    M = size(Train_Aobj,2);
    
    for i = 1 : M
        Network_Now{i} = TrainingSurrogateRBFN(Train_Adec, Train_Aobj(:,i), Center_num, 'Gaussian');
    end
    
    if isempty(model_pool{1, 1})
        Network = Network_Now;
        num = 0;
    else
        num = ModelPoolCensus(model_pool, pool_size);
        for j = 1 : num
            SingleRankChange(j, :) = ModelEstimate(Test_A, model_pool(j, :), miner, maxer);
        end
        
        for i = 1 : num
            Selected_index(i, :) = ModelSelect(SingleRankChange, i);
        end
        
        for i = 1 : num
            for j = 1 : M
                history_model{j, :} = model_pool(Selected_index{i, j}(1 : i, 1),j);
            end
            MultiRankChange(i, :) = MultiModelEstimate(Test_A, Network_Now, history_model, miner, maxer);
        end
        
        for i = 1 : M
            [~, index] = sort(MultiRankChange(:, i), 'ascend');
            Network{1,i} = model_pool(cell2mat(Selected_index(index(1, 1), i)),i);
            Network{1,i} = [Network{1,i}; Network_Now{i}];
        end 
    end
    
    if isempty(model_pool{pool_size, 1})
        model_pool(num + 1, :) = Network_Now;
    else
        model_pool(1, :) = [];
        model_pool(size(model_pool, 1) + 1, :) = Network_Now;
    end 
    
end