function [Centers, nn]=DiversitySampling(chromosome, tr_x, N, D, Ke)
    % Delete the multiple solutions between chromosome and the train data
    Q=[];P=[];
    for i=1:N
        PandQ=[tr_x;Q];
        matrix=dist(chromosome(i,1:D),PandQ');%1*size(PandQ,1) array
        if isempty(find(matrix<=10^-06))
            Q=[Q;chromosome(i,1:D)];
            P=[P;chromosome(i,:)];
        end
    end
    if size(Q,1)<Ke
        Centers=[];nn=100;
    else
        index=randperm(size(Q,1));
        Centers=Q(index(1:Ke),1:D);n=1;si=size(Q,1);
        % Cluster by the distance of the decision space
        while n<100

            NumberInClusters = zeros(Ke,1); % Number of samples in each class ,default is 0
            IndexInClusters = zeros(Ke,N); % Index of samples in each class
            % Classify all samples by the least distance principle
            for i = 1:si
                AllDistance = dist(Centers,Q(i,1:D)');% Calculate the distance between the i-th solution and each clustering center
                [~,Pos] = min(AllDistance);   % Minimum distance,training input is the index of clustering center
                NumberInClusters(Pos) = NumberInClusters(Pos) + 1;
                IndexInClusters(Pos,NumberInClusters(Pos)) = i;% Stores the training indexes belonging to this class in turn
            end
            % Store the old clustering centers
            OldCenters = Centers;
            % Recalculate the clustering centers
            for i = 1:Ke
                Index = IndexInClusters(i,1:NumberInClusters(i));% Extract the training input index belonging to this class
                Centers(i,:) = mean(Q(Index,1:D),1);    %Take the average of each class as the new clustering center
            end
            % Judge whether the old and new clustering centers are consistent
            EqualNum = sum(sum(Centers==OldCenters));% Centers and OldCenters are subtracted from each other to sum up all corresponding bits
            if EqualNum ==D*Ke % The old and new clustering centers are consistent
                break,
            end
            n=n+1;
        end
        nn=n;
    end
end