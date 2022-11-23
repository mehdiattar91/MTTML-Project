function FinalNet=PSO(Data,TData,Vars)
    %% Problem Definition

    EnsN=cell2mat(textscan(Vars{18},'%f'));                % DFNN Ensemble Number

    CostFunction=@(s) PSOParamSelectionCost(s, Data,EnsN); % Cost Function

    %Hidden Layer Number
    nVar.L=1;                                              % Number of Decision Variables [Layer Number]
    VarSize.L=[1 nVar.L];                                  % Size of Decision Variables Matrix

    VarMin.L=1;                                            % Lower Bound of Variables
    VarMax.L=cell2mat(textscan(Vars{19},'%f'));            % Upper Bound of Variables

    %Tap Delay
    nVar.T=1;                                              % Number of Decision Variables [Tap Delay]
    VarSize.T=[1 nVar.T];                                  % Size of Decision Variables Matrix

    VarMin.T=0;                                            % Lower Bound of Variables
    VarMax.T=cell2mat(textscan(Vars{20},'%f'));                                           % Upper Bound of Variables

    %Hidden Layer Neuron
    nVar.N=VarMax.L;                                       % Number of Decision Variables [Neuron Number]
    VarSize.N=[1 nVar.N];                                  % Size of Decision Variables Matrix

    VarMin.N=1;                                            % Lower Bound of Variables
    VarMax.N=cell2mat(textscan(Vars{21},'%f'));            % Upper Bound of Variables

    %All Features
    nVar.Total=nVar.L+...                                  % Number of Decision Variables [All Features]
        nVar.T+...
        nVar.N;       
    VarSize.Total=[1 nVar.Total];                          % Size of Decision Variables Matrix

    VarMin.Total=min([VarMin.L,VarMin.T,VarMin.N]);        % Lower Bound of Variables
    VarMax.Total=max([VarMax.L,VarMax.T,VarMax.N]);        % Upper Bound of Variables

    %% PSO Parameters

    MaxIt=cell2mat(textscan(Vars{22},'%f'));               % Maximum Number of Iterations

    nPop=cell2mat(textscan(Vars{23},'%f'));                % Population Size (Swarm Size)
    

    % Constriction Coefficients
    phi1=2.05;
    phi2=2.05;
    phi=phi1+phi2;
    chi=2/(phi-2+sqrt(phi^2-4*phi));
    w=chi;                                                 % Inertia Weight
    wdamp=1;                                               % Inertia Weight Damping Ratio
    c1=chi*phi1;                                           % Personal Learning Coefficient
    c2=chi*phi2;                                           % Global Learning Coefficient

    % Velocity Limits

    %Hidden Layer Number
    VelMax.L=0.5*(VarMax.L-VarMin.L);
    VelMin.L=-VelMax.L;

    %Tap Delay
    VelMax.T=0.2*(VarMax.T-VarMin.T);
    VelMin.T=-VelMax.T;

    %Hidden Layer Neuron
    VelMax.N=0.1*(VarMax.N-VarMin.N);
    VelMin.N=-VelMax.N;

    %% Initialization
    %
    disp('Initialization ...');
    %
    empty_particle.Position=[];
    empty_particle.Cost=[];
    empty_particle.Out=[];
    empty_particle.Velocity=[];
    empty_particle.Best.Position=[];
    empty_particle.Best.Cost=[];
    empty_particle.Best.Out=[];

    particle=repmat(empty_particle,nPop,1);

    BestSol.Cost=inf;

    for i=1:nPop

        % Initialize Position
        particle(i).Position=[unifrnd(VarMin.L,VarMax.L,VarSize.L),...
            unifrnd(VarMin.T,VarMax.T,VarSize.T),...
            unifrnd(VarMin.N,VarMax.N,VarSize.N)];

        % Initialize Velocity
        particle(i).Velocity=zeros(VarSize.Total);

        % Evaluation
        [particle(i).Cost, particle(i).Out]=CostFunction(particle(i).Position);

        % Update Personal Best
        particle(i).Best.Position=particle(i).Position;
        particle(i).Best.Cost=particle(i).Cost;
        particle(i).Best.Out=particle(i).Out;

        % Update Global Best
        if particle(i).Best.Cost<BestSol.Cost

            BestSol=particle(i).Best;

        end

    end

    BestCost=zeros(MaxIt,1);


    %% PSO Main Loop

    for it=1:MaxIt
        %
        disp(['Starting Iteration ' num2str(it) ' ...']);
        %
        for i=1:nPop

            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                +c1*rand(VarSize.Total).*(particle(i).Best.Position-particle(i).Position) ...
                +c2*rand(VarSize.Total).*(BestSol.Position-particle(i).Position);

            % Apply Velocity Limits

            %Hidden Layer Number
            particle(i).Velocity(1) = max(particle(i).Velocity(1),VelMin.L);
            particle(i).Velocity(1) = min(particle(i).Velocity(1),VelMax.L);

            %Tap Delay
            particle(i).Velocity(2) = max(particle(i).Velocity(2),VelMin.T);
            particle(i).Velocity(2) = min(particle(i).Velocity(2),VelMax.T);

            %Hidden Layer Neuron
            particle(i).Velocity(3:end) = max(particle(i).Velocity(3:end),VelMin.N);
            particle(i).Velocity(3:end) = min(particle(i).Velocity(3:end),VelMax.N);

            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;

            % Velocity Mirror Effect
            IsOutside=(particle(i).Position(1)<VarMin.L | particle(i).Position(1)>VarMax.L | ...
                particle(i).Position(2)<VarMin.T | particle(i).Position(2)>VarMax.T | ...
                particle(i).Position(3:end)<VarMin.N | particle(i).Position(3:end)>VarMax.N);

            particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);

            % Apply Position Limits

            %Hidden Layer Number
            particle(i).Position(1) = max(particle(i).Position(1),VarMin.L);
            particle(i).Position(1) = min(particle(i).Position(1),VarMax.L);

            %Tap Delay
            particle(i).Position(2) = max(particle(i).Position(2),VarMin.T);
            particle(i).Position(2) = min(particle(i).Position(2),VarMax.T);

            %Hidden Layer Neuron
            particle(i).Position(3:end) = max(particle(i).Position(3:end),VarMin.N);
            particle(i).Position(3:end) = min(particle(i).Position(3:end),VarMax.N);

            % Evaluation
            [particle(i).Cost, particle(i).Out] = CostFunction(particle(i).Position);

            % Update Personal Best
            if particle(i).Cost<particle(i).Best.Cost

                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Cost=particle(i).Cost;
                particle(i).Best.Out=particle(i).Out;

                % Update Global Best
                if particle(i).Best.Cost<BestSol.Cost

                    BestSol=particle(i).Best;

                end

            end

        end

        BestCost(it)=BestSol.Cost;

        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);

        w=w*wdamp;

    end

    %% Results

    disp('PSO-Result ...');

    %figure;
    %plot(BestCost,'LineWidth',2);
    %xlabel('Iteration');
    %ylabel('Best Cost');

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
    %Performance.RMSE=RMSEVECTOR;
    %Performance.COR=CORVECTOR;
    %Performance.NSE=NSEVECTOR;
    
    %Report
    Report.Ensemble=Ensemble;
    %Report.Performance=Performance;
    %Report.BestCost=BestCost;
    %Final Net
    FinalNet=Report;
end
