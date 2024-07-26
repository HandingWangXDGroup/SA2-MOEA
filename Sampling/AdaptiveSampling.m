function [New, flag] = AdaptiveSampling(A1, theta, kappa, PopDec, PopObj, MSE, FrontNo, CrowdDis, threshold, Network)

    s = MeasureEvolutionStage(A1, theta, kappa, Network);

    [N, D] = size(PopDec);
    if s < 0
        if rand < threshold
           New = ConvergenceSampling(PopDec,PopObj,1,kappa); 
           flag = 0;
        else
           New = UncertaintySampling(PopDec, MSE, 1);
           flag = 1;
        end
    else
        if rand < threshold
           New = DiversitySampling([PopDec,FrontNo',CrowdDis'], A1.decs, N, D, 1);
           flag = 0;
        else
           New = UncertaintySampling(PopDec, MSE, 1);
           flag = 1;
        end
    end
    
end