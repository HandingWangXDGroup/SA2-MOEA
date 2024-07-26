function RankChange = ModelEstimate(Test_A, model, miner, maxer)
    Test_Adec = Test_A.decs;
    Test_Adec = ArrrayNormalization(Test_Adec, miner, maxer);
    Test_Aobj = Test_A.objs;
    N = size(Test_Adec, 1);
    M = size(Test_Aobj, 2);
    
    Pred_Aobj = zeros(N, M);
    RankChange = zeros(1, M);
    for i = 1 : M
        Pred_Aobj(:, i) = PredictRBFN(Test_Adec, model{i});
        [~, pred_index] = sort(Pred_Aobj(:, i),'ascend');
        [~, true_index] = sort(Test_Aobj(:, i),'ascend');
        rank_change = abs(pred_index - true_index);
        RankChange(1, i) = sum(rank_change);        
    end
    
end