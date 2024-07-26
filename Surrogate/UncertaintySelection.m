function New_PopDec = UncertaintySelection(PopDec, MSE, N)
    
    for i = 1 : N
        Uncertainty = mean(MSE,2);
        [~,best]    = max(Uncertainty);
        New_PopDec(i,:) = PopDec(best,:);
        MSE(best,:) = [];
        PopDec(best,:) = [];
    end
end