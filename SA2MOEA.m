    %------------------------------- Reference --------------------------------
    % Nan Zheng, Handing Wang*, Jialin Liu, Formulating Approximation Error as Noise in Surrogate-Assisted 
    % Multi-Objective Evolutionary Algorithm, Swarm and Evolutionary Computation,  vol.10, pp. 101666, 2024.
    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 HandingWangXD Group. Permission is granted to copy and
    % use this code for research, noncommercial purposes, provided this
    % copyright notice is retained and the origin of the code is cited. The
    % code is provided "as is" and without any warranties, express or implied.
    %---------------------------- Parameter setting ---------------------------
    % Global.N    = 100--------The size of population
    % pool_size  = 5--------The maximum capacity of the model pool
    % theta = 0.2------The noisy threshold
    % cycle = 30-------The period of probability control
    % kappa = 0.05-------The scaling factor 
    % This code is written by Nan Zheng.
    % Email: Nanszheng@163.com

    clc; clear; warning off;
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    
%% Parameter Settings
    Global.problem = 'DTLZ1';
    Global.N = 100;
    Global.M = 3;
    Global.D = 30;
    Global.lower = zeros(1, Global.D);
    Global.upper = ones(1, Global.D);
    Global.evaluation = 300;
    Global.evaluated = 0;

    kappa = 0.05;
    wmax = 20;
    pool_size = 5;
    cycle = 30; 
    threshold = 0.5; 
    theta = 0.2;
    model_pool = cell(pool_size, Global.M); % model pool
    improvecount = 0; 
    keepcount = 0; 
    improvecount1 = 0; 
    keepcount2 = 0;
    %% Generate random population
    PopDec = unifrnd(repmat(Global.lower,Global.N,1),repmat(Global.upper,Global.N,1));
    [Population, Global] = INDIVIDUAL(PopDec, Global);
    A1 = Population;
    PopDec = Population.decs;
    tic;
    clc; fprintf('%s on %d-objective %d-variable (%6.2f%%), %.2fs passed...\n',Global.problem,Global.M,Global.D,Global.evaluated/Global.evaluation*100,toc);
    %% Optimization process
    while Global.evaluated < Global.evaluation
        % Model management
            [Train_A, Test_A] = DataDivision(A1);
            Center_num = ceil((size(Train_A, 2))); 
            [Network, model_pool] = ModelIntegrate(Train_A, Test_A, Center_num, model_pool, pool_size, Global.lower, Global.upper);
        
        % Surrogate-assisted evolution     
        PopDec = ArrrayNormalization(PopDec, Global.lower, Global.upper);
        PopObj = zeros(size(PopDec,1),Global.M);
        [PopObj, MSE] = HeteEnsemblePredict(PopDec, Network);
        w = 1;
        while w <= wmax
            MatingPool = TournamentSelection(2,Global.N,-CalFitness(PopObj,kappa));            
            OffDec = SAGA(PopDec(MatingPool', :),{1,20,1/Global.D,20});
            PopDec = [PopDec; OffDec];
            [N,~]  = size(PopDec);
            PopObj = zeros(N,Global.M);
            MSE    = zeros(N,Global.M);             
            [PopObj, MSE] = HeteEnsemblePredict(PopDec, Network);
            if rem(w, 2) == 1
                [PopDec,~] = IndicatorSelection(PopDec,PopObj,Global.N,kappa);
            else                
                [PopDec,FrontNo,CrowdDis] = DiversitySelection(PopDec,PopObj,Global.N);
            end
            
            PopObj = [];
            MSE = [];
            [PopObj, MSE] = HeteEnsemblePredict(PopDec, Network);
            w = w + 1;
            
        end

        New_PopDec = [];
        PopDec = ArrrayDenormalization(PopDec, Global.lower, Global.upper);
        while isempty(New_PopDec) && ~isempty(PopDec)

            % Infill sampling
            [New_PopDec, flag] = AdaptiveSampling(A1, theta, kappa, PopDec, PopObj, MSE, FrontNo, CrowdDis, threshold, Network);
            [New_PopDec, PopDec, MSE, FrontNo, CrowdDis] = CandidateCheck(New_PopDec, PopDec, MSE, FrontNo, CrowdDis, A1);
        end
        if ~isempty(New_PopDec)
            
            [New,Global] = INDIVIDUAL(New_PopDec, Global);
            [threshold, improvecount, keepcount, improvecount1, keepcount2] = ProbabilityAdjustment(A1, New, threshold, improvecount, keepcount, improvecount1, keepcount2, cycle, flag);
            A1 = [A1,New];
            [PopDec,~,~] = DiversitySelection(A1.decs,A1.objs,Global.N);
        else
            [PopDec,~,~] = DiversitySelection(A1.decs,A1.objs,Global.N);
        end
        clc; fprintf('%s on %d-objective %d-variable (%6.2f%%), %.2fs passed...\n',Global.problem,Global.M,Global.D,Global.evaluated/Global.evaluation*100,toc);
        
    end
    OutPopulation = A1;
  