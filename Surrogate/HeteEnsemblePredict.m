function [y_pred, s] = HeteEnsemblePredict(decs, Network)
    M = size(Network, 2);
    for i = 1 : M
        if size(Network{1, i}, 1) == 1
            y_obj = PredictRBFN(decs, Network{1, i});
        else
            y_obj = zeros(size(decs,1), size(Network{1, i}, 1));
            for j = 1 : size(Network{1, i}, 1)
                y_obj(:, j) = PredictRBFN(decs, Network{1, i}{j, 1});
            end            
        end

        y_pred(:, i) = mean(y_obj, 2);
        if size(Network{1, i}, 1) == 1
            y(:, i) = PredictRBFN(decs, Network{1, i});
        else
            y(:, i) = PredictRBFN(decs, Network{1, i}{end, 1});
        end
     
        if rand >= 0.5
            s(:, i) = MeasureUncertainty(y(:, i), y_pred(:, i));
        else
            s(:, i) = MeasureUncertainty(y_pred(:, i), y(:, i));
        end
    end


end