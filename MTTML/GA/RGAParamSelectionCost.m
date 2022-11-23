function [z, out]=RGAParamSelectionCost(s,Data,EnsN)

    % Read Data Elements
    %INPUTS=Data.INPUTS;
    %TARGETS=Data.TARGETS;
    
    % Selected Features
    SelectedFeatures=round(s);

    Params=NetworkParamMaker(SelectedFeatures);
    
    % Weights of Train and Test Errors
    WTrain=0.0;
    WTestandVal=1-WTrain;

    % Number of Runs
    NTrials=EnsN;
    MSEA=zeros(1,NTrials);
    RMSEA=zeros(1,NTrials);
    CORA=zeros(1,NTrials);
    NSEA=zeros(1,NTrials);
    for r=1:NTrials
        % Create and Train ANN
        TimeDelayNetResults=CreateTimeDelayNetFunction(Params,Data,false);

        % Calculate Overall Error
        MSEA(r) = WTrain*TimeDelayNetResults.TrainData.MSE ...
            + WTestandVal*TimeDelayNetResults.TestandValData.MSE;
        RMSEA(r) = WTrain*TimeDelayNetResults.TrainData.RMSE ...
            + WTestandVal*TimeDelayNetResults.TestandValData.RMSE;
        CORA(r) = WTrain*TimeDelayNetResults.TrainData.COR ...
            + WTestandVal*TimeDelayNetResults.TestandValData.COR;
        NSEA(r) = WTrain*TimeDelayNetResults.TrainData.NSE ...
            + WTestandVal*TimeDelayNetResults.TestandValData.NSE;
    end
    MSEG=mean(MSEA);
    RMSEG=mean(RMSEA);
    CORG=max(CORA);
    NSEG=mean(NSEA);
    
    if isinf(RMSEG)
        RMSEG=1e10;
    end
    % Calculate Final Cost
    z=RMSEG*(1);

    % Set Outputs
    out.SelectedFeatures=SelectedFeatures;
    out.MSE=MSEG;
    out.RMSE=RMSEG;
    out.COR=CORG;
    out.NSE=NSEG;
    out.z=z;

    
end
