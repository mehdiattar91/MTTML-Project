function FinalNet=SFS(Data,TData,Vars)
 
    %% SFS Parameters
    
    EnsN=cell2mat(textscan(Vars{3},'%f'));    
    MaxTapD=cell2mat(textscan(Vars{4},'%f'));
    MaxNeuron=cell2mat(textscan(Vars{5},'%f'));
    
    %% Finding The Best Network
    disp('Finding The Best Network ...');
    tic
    
    FinalBestNetworkSet=zeros(MaxTapD,2,MaxNeuron);
    it=0; %Iteration Counter
    for Tk=1:MaxTapD+1
        it=it+1;
        if Tk==1
            Params.TapDelay=Tk-1;
        elseif Tk>1
            Params.TapDelay=1:Tk-1;
        end    
        for Nk=1:MaxNeuron
            Params.HLN=Nk;
            Cost=SFSCost(Params,Data,EnsN);
            FinalBestNetworkSet(Tk,1,Nk)=Nk;
            FinalBestNetworkSet(Tk,2,Nk)=Cost.RMSE;
            disp(['Iteration ' num2str(it),' ',num2str(Nk)]);
        end
    end
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %THE BEST NETWORK NEURON NUMBER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('The Best Network ...');

    BestPerformance=min(min(FinalBestNetworkSet(:,2,:)));
    
    for i = 1:MaxTapD+1
        for ii = 1:MaxNeuron
            if FinalBestNetworkSet(i,2,ii)== BestPerformance
                TPInd=i-1;
                NPInd=ii;
            end
        end
    end
    %
    if TPInd == 0
        Params.TapDelay=TPInd;
    elseif TPInd > 1
        Params.TapDelay=1:TPInd;
    end
    Params.HLN=FinalBestNetworkSet(TPInd+1,1,NPInd);
    WTrain=0.0;
    WTestandVal=1-WTrain;
    %
    TimeTapDelayNetResultsCELL=cell(1,EnsN);
    RMSEVECTOR=zeros(1,EnsN);
    CORVECTOR=zeros(1,EnsN);
    NSEVECTOR=zeros(1,EnsN);

    disp('The Ensemble Network ...');

    for i = 1 : EnsN

        TimeTapDelayNetResults=CreateTimeDelayNetFunction(Params,Data,false);
        RMSE = WTrain*TimeTapDelayNetResults.TrainData.RMSE + WTestandVal*TimeTapDelayNetResults.TestandValData.RMSE;
        COR = WTrain*TimeTapDelayNetResults.TrainData.COR + WTestandVal*TimeTapDelayNetResults.TestandValData.COR;
        NSE = WTrain*TimeTapDelayNetResults.TrainData.NSE + WTestandVal*TimeTapDelayNetResults.TestandValData.NSE;

        TimeTapDelayNetResultsCELL{i}=TimeTapDelayNetResults;
        RMSEVECTOR(i)=RMSE;
        CORVECTOR(i)=COR;
        NSEVECTOR(i)=NSE;

        disp(['Ensemble - Iteration ' num2str(i)]);
    end
    %Ensemble Process
    Ensemble=NetEnsemble(TimeTapDelayNetResultsCELL,Data,TData);

    %Performance of individual Network
    %Performance.RMSE=RMSEVECTOR;
    %Performance.COR=CORVECTOR;
    %Performance.NSE=NSEVECTOR;
    
    %Report
    Report.Ensemble=Ensemble;
    %Report.Performance=Performance;
    %Final Net
    FinalNet=Report;
    toc
    
end