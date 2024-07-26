function s = MeasureEvolutionStage(A1, theta, kappa, Network)

    PopObj = A1.objs;
    PopDec = A1.decs;
    ND = NDSort(PopObj, 1);    
    NondPopObj = PopObj(ND==1, :);
    NondPopDec = PopDec(ND==1, :);
    [PredPopObj, ~] = HeteEnsemblePredict(NondPopDec, Network);
    DPopObj = PopObj(ND==inf, :);  
    sigma2 = CalculateVariance(PredPopObj, NondPopObj);
    [lamreev, M] = size(NondPopObj);
    
%     NewPopObjAdd = NondPopObj + sign(2*rand(lamreev, M)-1);
    NewPopObjAdd = NondPopObj + mvnrnd(zeros(1,M), diag(sigma2),lamreev);
    NewPopObj = [NewPopObjAdd;DPopObj];
    PopObj = [NondPopObj;DPopObj];
    PopFitness = CalFitness(PopObj,kappa);
    NewPopFitness = CalFitness(NewPopObj,kappa);
    [s, ~, ~] = Measurement(PopFitness, NewPopFitness, lamreev, theta);
    
end



function [s, ranks, rankDelta] = Measurement(arf1, arf2, lamreev, theta)

        if size(arf1,1) ~= size(arf2,1)         
           error('arf1 and arf2 must be same in size 1'); 
        elseif size(arf1,2) ~= size(arf1,2)
            error('arf1 and arf2 must be same in size 2');
        elseif size(arf1,1) ~= 1
            error('arf1 and arf2 must be an 1x lamda array');
        end
        lam=size(arf1,2);
        [~,idx] = sort([arf1,arf2]);
        [~,ranks] = sort(idx);
        ranks = reshape(ranks,lam,2)';
        
        rankDelta = ranks(1,:)-ranks(2,:)-sign(ranks(1,:)-ranks(2,:));
        
        for i = 1:lamreev
            sumlim(i)=...
                prctile(abs((1:2*lam-1) - (ranks(1,i)-(ranks(1,i)>ranks(2,i)))),...
                        theta*50)+...
                prctile(abs((1:2*lam-1) - (ranks(2,i)-(ranks(2,i)>ranks(1,i)))),...
                        theta*50);
        end
        
        s = mean(2*abs(rankDelta(1:lamreev)) - sumlim);
        
end


function sigma2 = CalculateVariance(Predobj, Obj)
    delta = Predobj - Obj;
    NormObj = (abs(delta))';

    sigma2 = median(NormObj, 2);
end