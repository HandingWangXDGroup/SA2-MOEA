function [y_pred, s] = HeteEnsemblePredictV2(decs, centers, Network1, Network2)
    
    M = size(Network1,2);
    %% Multi-surrogates ensemble
    for i = 1 : M
        y1(:,i) = PredictRBFN(decs, Network1);
        y2(:,i) = PredictRBF(decs, centers, Network2);
    end
    y_pred = (y1 + y2)/2;
    %% Uncertainty measurement
    if rand >= 0.5
        s = MeasureUncertainty(y1, y2);
    else
        s = MeasureUncertainty(y2, y1);
    end
    
end