function [z, out]=PSOParamSelectionCost(s,Data,EnsN)

    % Read Data Elements
    %INPUTS=Data.INPUTS;
    %TARGETS=Data.TARGETS;
    
    % Selected Features
    SelectedFeatures=round(s);
    
    Params=NetworkParamMaker(SelectedFeatures);
    
    % Selecting Features
    % HLNandTapDelay.HLN=Param.HLN;
    % HLNandTapDelay.TapDelay=Param.TapDelay;
    
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
        %MSE
        MSEA(r) = WTrain*TimeDelayNetResults.TrainData.MSE + ...
            WTestandVal*TimeDelayNetResults.TestandValData.MSE;
        %RMSE
        RMSEA(r) = WTrain*TimeDelayNetResults.TrainData.RMSE + ...
            WTestandVal*TimeDelayNetResults.TestandValData.RMSE;
        %COR
        CORA(r) = WTrain*TimeDelayNetResults.TrainData.COR + ...
            WTestandVal*TimeDelayNetResults.TestandValData.COR;
        %NSE
        NSEA(r) = WTrain*TimeDelayNetResults.TrainData.NSE + ...
            WTestandVal*TimeDelayNetResults.TestandValData.NSE;
    end
    MSEG=mean(MSEA);
    RMSEG=mean(RMSEA);
    CORG=max(CORA);
    NSEG=mean(RMSEA);

    % Calculate Final Cost
    z=RMSEG*(1);
    %if isinf(RMSEG)
    %    RMSEG=1e10;
    %end
    % Set Outputs
    out.SelectedFeatures=SelectedFeatures;
    out.MSE=MSEG;
    out.RMSE=RMSEG;
    out.COR=CORG;
    out.NSE=NSEG;
    out.z=z;
    
end
