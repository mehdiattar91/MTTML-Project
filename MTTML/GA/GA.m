function FinalNet=GA(Data,TData,Vars)
    %% Problem Definition

    EnsN=cell2mat(textscan(Vars{7},'%f'));                % DFNN Ensemble Number
    
    CostFunction=@(s) RGAParamSelectionCost(s,Data,EnsN); % Cost Function

    %Layer Number
    nVar.L=1;                                             % Number of Decision Variables [Layers Number]
    VarSize.L=[1 nVar.L];                                 % Decision Variables Matrix Size

    VarMin.L=1;                                           % Lower Bound of Variables
    VarMax.L=cell2mat(textscan(Vars{8},'%f'));            % Upper Bound of Variables

    %TapDelay
    nVar.T=1;                                             % Number of Decision Variables [Tap Delay]
    VarSize.T=[1 nVar.T];                                 % Decision Variables Matrix Size

    VarMin.T=0;                                           % Lower Bound of Variables
    VarMax.T=cell2mat(textscan(Vars{9},'%f'));            % Upper Bound of Variables

    %Neuron Number
    nVar.N=VarMax.L;                                      % Number of Decision Variables [Neuron Number]
    VarSize.N=[1 nVar.N];                                 % Decision Variables Matrix Size

    VarMin.N=1;                                           % Lower Bound of Variables
    VarMax.N=cell2mat(textscan(Vars{10},'%f'));           % Upper Bound of Variables

    %% GA Parameters

    MaxIt=cell2mat(textscan(Vars{11},'%f'));              % Maximum Number of Iterations

    nPop=cell2mat(textscan(Vars{12},'%f'));               % Population Size

    pc=cell2mat(textscan(Vars{13},'%f'));                 % Crossover Percentage
    nc=2*round(pc*nPop/2);                                % Number of Offsprings (Parnets)

    pm=cell2mat(textscan(Vars{14},'%f'));                 % Mutation Percentage
    nm=round(pm*nPop);                                    % Number of Mutants

    gamma=0.1;

    mu=cell2mat(textscan(Vars{15},'%f'));                 % Mutation Rate

    beta=cell2mat(textscan(Vars{16},'%f'));               % Selection Pressure
    
    %% Initialization
    %
    disp('Initialization ...');
    %
    empty_individual.Position=[];
    empty_individual.Cost=[];
    empty_individual.Out=[];

    pop=repmat(empty_individual,nPop,1);

    for i=1:nPop

        % Initialize Position
        pop(i).Position=[unifrnd(VarMin.L, VarMax.L, VarSize.L),...
            unifrnd(VarMin.T, VarMax.T, VarSize.T),...
            unifrnd(VarMin.N, VarMax.N, VarSize.N)];

        % Evaluation
        [pop(i).Cost, pop(i).Out]=CostFunction(pop(i).Position);

    end

    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);

    % Store Best Solution
    BestSol=pop(1);

    % Array to Hold Best Cost Values
    BestCost=zeros(MaxIt,1);

    % Store Cost
    WorstCost=pop(end).Cost;


    %% Main Loop

    for it=1:MaxIt
        %
        disp(['Starting Iteration ' num2str(it) ' ...']);
        %
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);

        % Crossover
        popc=repmat(empty_individual,nc/2,2);
        for k=1:nc/2

            % Select Parents Indices
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);

            % Select Parents
            p1=pop(i1);
            p2=pop(i2);

            % Apply Crossover
            [popc(k,1).Position, popc(k,2).Position]=...
                Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);

            % Evaluate Offsprings
            [popc(k,1).Cost, popc(k,1).Out]=CostFunction(popc(k,1).Position);
            [popc(k,2).Cost, popc(k,2).Out]=CostFunction(popc(k,2).Position);

        end
        popc=popc(:);


        % Mutation
        popm=repmat(empty_individual,nm,1);
        for k=1:nm

            % Select Parent
            i=randi([1 nPop]);
            p=pop(i);

            % Apply Mutation
            popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax);

            % Evaluate Mutant
            [popm(k).Cost, popm(k).Out]=CostFunction(popm(k).Position);

        end

        % Create Merged Population
        pop=[pop
             popc
             popm]; %#ok

        % Sort Population
        Costs=[pop.Cost];
        [Costs, SortOrder]=sort(Costs);
        pop=pop(SortOrder);

        % Update Worst Cost
        WorstCost=max(WorstCost,pop(end).Cost);

        % Truncation
        pop=pop(1:nPop);
        Costs=Costs(1:nPop);

        % Store Best Solution Ever Found
        BestSol=pop(1);

        % Store Best Cost Ever Found
        BestCost(it)=BestSol.Cost;

        % Show Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);

    end

    %% Results

    disp('Ga-Result ...');

    %figure;
    %plot(BestCost,'LineWidth',2);
    %title('Ga-Result')
    %xlabel('Iteration');
    %ylabel('Cost');
    %%
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %THE BEST NETWORK NEURON NUMBER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('Final Network ...');
    %
    %%%%%%%%%%%%%%
    %Netwotk Parms
    %%%%%%%%%%%%%%
    %
    SelectedFeatures=BestSol.Out.SelectedFeatures;

    Params=NetworkParamMaker(SelectedFeatures);

    WTrain=0.0;
    WTestandVal=1-WTrain;

    %
    TimeDelayNetResultsCELL=cell(1,EnsN);
    RMSEVECTOR=zeros(1,EnsN);
    CORVECTOR=zeros(1,EnsN);
    NSEVECTOR=zeros(1,EnsN);

    disp('The Ensemble Network ...');

    for i =1 : EnsN

        TimeDelayNetResults=CreateTimeDelayNetFunction(Params,Data,false);
        RMSE = WTrain*TimeDelayNetResults.TrainData.RMSE + WTestandVal*TimeDelayNetResults.TestandValData.RMSE;
        COR = WTrain*TimeDelayNetResults.TrainData.COR + WTestandVal*TimeDelayNetResults.TestandValData.COR;
        NSE = WTrain*TimeDelayNetResults.TrainData.NSE + WTestandVal*TimeDelayNetResults.TestandValData.NSE;

        TimeDelayNetResultsCELL{i}=TimeDelayNetResults;
        RMSEVECTOR(i)=RMSE;
        CORVECTOR(i)=COR;
        NSEVECTOR(i)=NSE;


        disp(['Ensemble - Iteration ' num2str(i)]);
    end

    %Ensemble Process
    Ensemble=NetEnsemble(TimeDelayNetResultsCELL,Data,TData);

    %Performance of individual Network
    Performance.RMSE=RMSEVECTOR;
    Performance.COR=CORVECTOR;
    Performance.NSE=NSEVECTOR;
    %Report
    Report.Ensemble=Ensemble;
    Report.Performance=Performance;
    Report.BestCost=BestCost;
    %Final Net
    FinalNet=Report;
end