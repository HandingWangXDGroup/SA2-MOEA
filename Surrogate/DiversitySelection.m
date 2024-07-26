function [PopDec,FrontNo,CrowdDis] = DiversitySelection(PopDec,PopObj,N)
    %% Non-dominated sorting
    [FrontNo,MaxFNo] = NDSort(PopObj,[],N);
    Next = FrontNo < MaxFNo;
    
    %% Calculate the crowding distance of each solution
    CrowdDis = CrowdingDistance(PopObj,FrontNo);
    
    %% Select the solutions in the last front based on their crowding distances
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    
    %% Population for next generation
    PopDec = PopDec(Next,:);
    FrontNo    = FrontNo(Next);
    CrowdDis   = CrowdDis(Next);


end