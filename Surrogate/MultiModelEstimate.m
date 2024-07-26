function RankChange = MultiModelEstimate(Test_A, model_now, model_select, miner, maxer)
        Test_Adec = Test_A.decs;
        Test_Adec = ArrrayNormalization(Test_Adec, miner, maxer);
        Test_Aobj = Test_A.objs;
        N = size(Test_Adec, 1);
        M = size(Test_Aobj, 2);
        
        Pred_Mobj = zeros(N, size(model_select, 2) + 1);
        Pred_Aobj = zeros(N, M);
        RankChange = zeros(1, M);
        for i = 1 : M
            Pred_Mobj(:, 1) = PredictRBFN(Test_Adec, model_now{i});
            for j = 1 : size(model_select{1,1}, 1)
               Pred_Mobj(:, j + 1) = PredictRBFN(Test_Adec, model_select{i,1}{j, 1});
            end
            Pred_Aobj(:, i) = mean(Pred_Mobj, 2);
            [~, pred_index] = sort(Pred_Aobj(:, i),'ascend');
            [~, true_index] = sort(Test_Aobj(:, i),'ascend');
            rank_change = abs(pred_index - true_index);
            RankChange(1, i) = sum(rank_change);    
        end
        

end