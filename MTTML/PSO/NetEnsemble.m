function[Ensemble]=NetEnsemble(TimeDelayNetResultsCELL,Data,TData)

    %%
    %Making Data Ready for ONE Regression Plot
    [~,NumberOfNetworks]=size(TimeDelayNetResultsCELL);
    for i =1:NumberOfNetworks
        Results=TimeDelayNetResultsCELL{i};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Copy Data To Ensemble
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Net
        Ensemble.CELL{i}.Net=Results.Net;
        %Training Data
        Ensemble.CELL{i}.TrainData.Targets=Results.TrainData.Targets;
        Ensemble.CELL{i}.TrainData.Outputs=Results.TrainData.Outputs;
        Ensemble.CELL{i}.TrainData.Ind=Results.TrainData.Ind;

        %Validation Data
        Ensemble.CELL{i}.ValData.Targets=Results.ValData.Targets;
        Ensemble.CELL{i}.ValData.Outputs=Results.ValData.Outputs;
        Ensemble.CELL{i}.ValData.Ind=Results.ValData.Ind;
        
        %Test Data
        Ensemble.CELL{i}.TestData.Targets=Results.TestData.Targets;
        Ensemble.CELL{i}.TestData.Outputs=Results.TestData.Outputs;
        Ensemble.CELL{i}.TestData.Ind=Results.TestData.Ind;
        
        %Test and Validation Data
        Ensemble.CELL{i}.TestandValData.Targets=Results.TestandValData.Targets;
        Ensemble.CELL{i}.TestandValData.Outputs=Results.TestandValData.Outputs;
        Ensemble.CELL{i}.TestandValData.Ind=Results.TestandValData.Ind;
        
        %All Data
        Ensemble.CELL{i}.AllData.Targets=Results.AllData.Targets;
        Ensemble.CELL{i}.AllData.Outputs=Results.AllData.Outputs;
        Ensemble.CELL{i}.AllData.Ind=Results.AllData.Ind;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Turning Cell To Vector
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %All Data
        Ensemble.VEC{i}.AllData.Targets= cell2mat(Ensemble.CELL{i}.AllData.Targets);
        Ensemble.VEC{i}.AllData.Outputs= cell2mat(Ensemble.CELL{i}.AllData.Outputs);
        Ensemble.VEC{i}.AllData.Ind=Ensemble.CELL{i}.AllData.Ind;
        
        %Training Data
        Ensemble.VEC{i}.TrainData.Targets=cell2mat(Ensemble.CELL{i}.TrainData.Targets);
        Ensemble.VEC{i}.TrainData.Outputs= cell2mat(Ensemble.CELL{i}.TrainData.Outputs);
        Ensemble.VEC{i}.TrainData.Ind=Ensemble.CELL{i}.TrainData.Ind;
        
        %validation Data
        Ensemble.VEC{i}.ValData.Targets=cell2mat(Ensemble.CELL{i}.ValData.Targets);
        Ensemble.VEC{i}.ValData.Outputs= cell2mat(Ensemble.CELL{i}.ValData.Outputs);
        Ensemble.VEC{i}.ValData.Ind=Ensemble.CELL{i}.ValData.Ind;
        
        %Test Data
        Ensemble.VEC{i}.TestData.Targets=cell2mat(Ensemble.CELL{i}.TestData.Targets);
        Ensemble.VEC{i}.TestData.Outputs= cell2mat(Ensemble.CELL{i}.TestData.Outputs);
        Ensemble.VEC{i}.TestData.Ind=Ensemble.CELL{i}.TestData.Ind;
        
        %Test and Validation Data
        Ensemble.VEC{i}.TestandValData.Targets=cell2mat(Ensemble.CELL{i}.TestandValData.Targets);
        Ensemble.VEC{i}.TestandValData.Outputs= cell2mat(Ensemble.CELL{i}.TestandValData.Outputs);
        Ensemble.VEC{i}.TestandValData.Ind=Ensemble.CELL{i}.TestandValData.Ind;
        
    end
    %%   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Combinining Vectors into Matrix Based on Index 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %All Data
    [~,S]=size(Ensemble.VEC{i}.AllData.Targets);
    [~,SS]=size(Ensemble.VEC{i}.AllData.Targets);

    TMAT=zeros(NumberOfNetworks,S);
    OMAT=zeros(NumberOfNetworks,S);
    for i =1:NumberOfNetworks
        j=1;
        for ii= 1:S
            if ii == Ensemble.VEC{i}.AllData.Ind(1,j)
                TMAT(i,ii)=Ensemble.VEC{i}.AllData.Targets(1,j);
                OMAT(i,ii)=Ensemble.VEC{i}.AllData.Outputs(1,j);
                j=j+1;
                if j > SS
                    j=SS;
                end
            end
        end
    end
    TMAT(TMAT==0)=NaN;
    OMAT(OMAT==0)=NaN;
    Ensemble.MAT.AllData.Targets=TMAT;
    Ensemble.MAT.AllData.Outputs=OMAT;

    %Training Data
    [~,S]=size(Ensemble.VEC{i}.AllData.Targets);
    [~,SS]=size(Ensemble.VEC{i}.TrainData.Targets);
    TMAT=zeros(NumberOfNetworks,S);
    OMAT=zeros(NumberOfNetworks,S);
    for i =1:NumberOfNetworks
        j=1;
        for ii= 1:S
            if ii == Ensemble.VEC{i}.TrainData.Ind(1,j)
                TMAT(i,ii)=Ensemble.VEC{i}.TrainData.Targets(1,j);
                OMAT(i,ii)=Ensemble.VEC{i}.TrainData.Outputs(1,j);
                j=j+1;
                if j > SS
                    j=SS;
                end
            end
        end
    end
    TMAT(TMAT==0)=NaN;
    OMAT(OMAT==0)=NaN;
    Ensemble.MAT.TrainData.Targets=TMAT;
    Ensemble.MAT.TrainData.Outputs=OMAT;

    %Validation Data
    [~,S]=size(Ensemble.VEC{i}.AllData.Targets);
    [~,SS]=size(Ensemble.VEC{i}.ValData.Targets);
    TMAT=zeros(NumberOfNetworks,S);
    OMAT=zeros(NumberOfNetworks,S);
    for i =1:NumberOfNetworks
        j=1;
        for ii= 1:S
            if ii == Ensemble.VEC{i}.ValData.Ind(1,j)
                TMAT(i,ii)=Ensemble.VEC{i}.ValData.Targets(1,j);
                OMAT(i,ii)=Ensemble.VEC{i}.ValData.Outputs(1,j);
                j=j+1;
                if j > SS
                    j=SS;
                end
            end
        end
    end
    TMAT(TMAT==0)=NaN;
    OMAT(OMAT==0)=NaN;
    Ensemble.MAT.ValData.Targets=TMAT;
    Ensemble.MAT.ValData.Outputs=OMAT;

    %Test Data
    [~,S]=size(Ensemble.VEC{i}.AllData.Targets);
    [~,SS]=size(Ensemble.VEC{i}.TestData.Targets);
    TMAT=zeros(NumberOfNetworks,S);
    OMAT=zeros(NumberOfNetworks,S);
    for i =1:NumberOfNetworks
        j=1;
        for ii= 1:S
            if ii == Ensemble.VEC{i}.TestData.Ind(1,j)
                TMAT(i,ii)=Ensemble.VEC{i}.TestData.Targets(1,j);
                OMAT(i,ii)=Ensemble.VEC{i}.TestData.Outputs(1,j);
                j=j+1;
                if j > SS
                    j=SS;
                end
            end
        end
    end
    TMAT(TMAT==0)=NaN;
    OMAT(OMAT==0)=NaN;
    Ensemble.MAT.TestData.Targets=TMAT;
    Ensemble.MAT.TestData.Outputs=OMAT;

     %Test and Validation Data
    [~,S]=size(Ensemble.VEC{i}.AllData.Targets);
    [~,SS]=size(Ensemble.VEC{i}.TestandValData.Targets);
    TMAT=zeros(NumberOfNetworks,S);
    OMAT=zeros(NumberOfNetworks,S);
    for i =1:NumberOfNetworks
        j=1;
        for ii= 1:S
            if ii == Ensemble.VEC{i}.TestandValData.Ind(1,j)
                TMAT(i,ii)=Ensemble.VEC{i}.TestandValData.Targets(1,j);
                OMAT(i,ii)=Ensemble.VEC{i}.TestandValData.Outputs(1,j);
                j=j+1;
                if j > SS
                    j=SS;
                end
            end
        end
    end
    TMAT(TMAT==0)=NaN;
    OMAT(OMAT==0)=NaN;
    Ensemble.MAT.TestandValData.Targets=TMAT;
    Ensemble.MAT.TestandValData.Outputs=OMAT; 
    %%
    %Ensembeled Timeseries
    TimeseriesCELL=cell(1,NumberOfNetworks);
    for k = 1:NumberOfNetworks
        Results=TimeDelayNetResultsCELL{k};
        [~,xi,ai,~] = preparets(Results.Net,Data.INPUTS,Data.TARGETS);
        [~,is]=size(xi);
        for i = 1 : is 
            xi{1,i}=Data.INPUTS{1,end-is+i};
        end
        x=Data.INPUTS;
        ExactTimeSeriesNetOutput = Results.Net(x,xi,ai);
        %[~,Es]=size(IExactTimeSeriesNetOutput);
        %Eh=365-Es;
        %ExactTimeSeriesNetOutput=cell(1,365);
        %for i=1:365
        %    if i<=Eh
        %        ExactTimeSeriesNetOutput{1,i}= NaN;
        %    else
        %        ExactTimeSeriesNetOutput{1,i}=IExactTimeSeriesNetOutput{1,i-Eh};
        %    end
        %end
        j=1;
        [~,s]=size(TData.R);
        Response=zeros(2,365);
        for i = 1:365
            if TData.R(1,j)==i
                j=j+1;
                if j>s
                    j=s;
                end
                Response(1,i)=i;
                Response(2,i)=ExactTimeSeriesNetOutput{1,j};
            else
                Response(1,i)=i;
                Response(2,i)=NaN;
            end
        end
        TimeseriesCELL{k}=Response; 
    end
    %Ensemble Time Series
    [~,S]=size(TimeseriesCELL{1});
    TimeseriesMat=zeros(NumberOfNetworks,S);
    for i = 1 :NumberOfNetworks
        TimeseriesMat(i,:)=TimeseriesCELL{i}(2,:);
    end
    EnsembleTimeseries(1,:)=TimeseriesCELL{1}(1,:);
    EnsembleTimeseries(2,:)=nanmean(TimeseriesMat);
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Final Ensemble Results
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Net
    Ensemble.ENS.Net=Ensemble.CELL{1}.Net;
    %All Data
    Ensemble.ENS.AllData.Targets=nanmean(Ensemble.MAT.AllData.Targets);
    Ensemble.ENS.AllData.Outputs=nanmean(Ensemble.MAT.AllData.Outputs);
    %Omiting NaN
    Ensemble.ENS.AllData.Targets=Ensemble.ENS.AllData.Targets(~isnan(Ensemble.ENS.AllData.Targets));
    Ensemble.ENS.AllData.Outputs=Ensemble.ENS.AllData.Outputs(~isnan(Ensemble.ENS.AllData.Outputs));

    %Performance
    %MSE
    Yp=Ensemble.ENS.AllData.Outputs;
    Yo=Ensemble.ENS.AllData.Targets;
    Ensemble.ENS.AllData.MSE=mean((Yo-Yp).^2);
    %RMSE
    Ensemble.ENS.AllData.RMSE=sqrt(Ensemble.ENS.AllData.MSE);
    Ensemble.ENS.AllData.NRMSE=Ensemble.ENS.AllData.RMSE/mean(Ensemble.ENS.AllData.Targets);
    %NSE
    Yp=Ensemble.ENS.AllData.Outputs;
    Yo=Ensemble.ENS.AllData.Targets;
    YoMean=mean(Yo);
    Ensemble.ENS.AllData.NSE=1-sum((Yp-Yo).^2)/sum((Yo-YoMean).^2);
    %Correlation
    x=Ensemble.ENS.AllData.Outputs;
    y=Ensemble.ENS.AllData.Targets;
    Ensemble.ENS.AllData.COR=corr(x',y');


    %Training Data
    Ensemble.ENS.TrainData.Targets=nanmean(Ensemble.MAT.TrainData.Targets);
    Ensemble.ENS.TrainData.Outputs=nanmean(Ensemble.MAT.TrainData.Outputs);
    %Omiting NaN
    Ensemble.ENS.TrainData.Targets=Ensemble.ENS.TrainData.Targets(~isnan(Ensemble.ENS.TrainData.Targets));
    Ensemble.ENS.TrainData.Outputs=Ensemble.ENS.TrainData.Outputs(~isnan(Ensemble.ENS.TrainData.Outputs));

    %Performance
    %MSE
    Yp=Ensemble.ENS.TrainData.Outputs;
    Yo=Ensemble.ENS.TrainData.Targets;
    Ensemble.ENS.TrainData.MSE=mean((Yo-Yp).^2);
    %RMSE
    Ensemble.ENS.TrainData.RMSE=sqrt(Ensemble.ENS.TrainData.MSE);
    Ensemble.ENS.TrainData.NRMSE=Ensemble.ENS.TrainData.RMSE/mean(Ensemble.ENS.TrainData.Targets);
    %NSE
    Yp=Ensemble.ENS.TrainData.Outputs;
    Yo=Ensemble.ENS.TrainData.Targets;
    YoMean=mean(Yo);
    Ensemble.ENS.TrainData.NSE=1-sum((Yp-Yo).^2)/sum((Yo-YoMean).^2);
    %Correlation
    x=Ensemble.ENS.TrainData.Outputs;
    y=Ensemble.ENS.TrainData.Targets;
    Ensemble.ENS.TrainData.COR=corr(x',y');

    %Test Data
    Ensemble.ENS.TestData.Targets=nanmean(Ensemble.MAT.TestData.Targets);
    Ensemble.ENS.TestData.Outputs=nanmean(Ensemble.MAT.TestData.Outputs);
    %Omiting 
    Ensemble.ENS.TestData.Targets=Ensemble.ENS.TestData.Targets(~isnan(Ensemble.ENS.TestData.Targets));
    Ensemble.ENS.TestData.Outputs=Ensemble.ENS.TestData.Outputs(~isnan(Ensemble.ENS.TestData.Outputs));

    %Performance
    %MSE
    Yp=Ensemble.ENS.TestData.Outputs;
    Yo=Ensemble.ENS.TestData.Targets;
    Ensemble.ENS.TestData.MSE=mean((Yo-Yp).^2);
    %RMSE
    Ensemble.ENS.TestData.RMSE=sqrt(Ensemble.ENS.TestData.MSE);
    Ensemble.ENS.TestData.NRMSE=Ensemble.ENS.TestData.RMSE/mean(Ensemble.ENS.TestData.Targets);
    %NSE
    Yp=Ensemble.ENS.TestData.Outputs;
    Yo=Ensemble.ENS.TestData.Targets;
    YoMean=mean(Yo);
    Ensemble.ENS.TestData.NSE=1-sum((Yp-Yo).^2)/sum((Yo-YoMean).^2);
    %Correlation
    x=Ensemble.ENS.TestData.Outputs;
    y=Ensemble.ENS.TestData.Targets;
    Ensemble.ENS.TestData.COR=corr(x',y');


    %Validation Data
    Ensemble.ENS.ValData.Targets=nanmean(Ensemble.MAT.ValData.Targets);
    Ensemble.ENS.ValData.Outputs=nanmean(Ensemble.MAT.ValData.Outputs);
    %Omiting NaN
    Ensemble.ENS.ValData.Targets=Ensemble.ENS.ValData.Targets(~isnan(Ensemble.ENS.ValData.Targets));
    Ensemble.ENS.ValData.Outputs=Ensemble.ENS.ValData.Outputs(~isnan(Ensemble.ENS.ValData.Outputs));

    %Performance
    %MSE
    Yp=Ensemble.ENS.ValData.Outputs;
    Yo=Ensemble.ENS.ValData.Targets;
    Ensemble.ENS.ValData.MSE=mean((Yo-Yp).^2);
    %RMSE
    Ensemble.ENS.ValData.RMSE=sqrt(Ensemble.ENS.ValData.MSE);
    Ensemble.ENS.ValData.NRMSE=Ensemble.ENS.ValData.RMSE/mean(Ensemble.ENS.ValData.Targets);
    %NSE
    Yp=Ensemble.ENS.ValData.Outputs;
    Yo=Ensemble.ENS.ValData.Targets;
    YoMean=mean(Yo);
    Ensemble.ENS.ValData.NSE=1-sum((Yp-Yo).^2)/sum((Yo-YoMean).^2);
    %Correlation
    x=Ensemble.ENS.ValData.Outputs;
    y=Ensemble.ENS.ValData.Targets;
    Ensemble.ENS.ValData.COR=corr(x',y');


    %Test and Validation Data
    Ensemble.ENS.TestandValData.Targets=nanmean(Ensemble.MAT.TestandValData.Targets);
    Ensemble.ENS.TestandValData.Outputs=nanmean(Ensemble.MAT.TestandValData.Outputs);
    %Omiting NaN
    Ensemble.ENS.TestandValData.Targets=Ensemble.ENS.TestandValData.Targets(~isnan(Ensemble.ENS.TestandValData.Targets));
    Ensemble.ENS.TestandValData.Outputs=Ensemble.ENS.TestandValData.Outputs(~isnan(Ensemble.ENS.TestandValData.Outputs));

    %Performance
    %MSE
    Yp=Ensemble.ENS.TestandValData.Outputs;
    Yo=Ensemble.ENS.TestandValData.Targets;
    Ensemble.ENS.TestandValData.MSE=mean((Yo-Yp).^2);
    %RMSE
    Ensemble.ENS.TestandValData.RMSE=sqrt(Ensemble.ENS.TestandValData.MSE);
    Ensemble.ENS.TestandValData.NRMSE=Ensemble.ENS.TestandValData.RMSE/mean(Ensemble.ENS.TestandValData.Targets);
    %NSE
    Yp=Ensemble.ENS.TestandValData.Outputs;
    Yo=Ensemble.ENS.TestandValData.Targets;
    YoMean=mean(Yo);
    Ensemble.ENS.TestandValData.NSE=1-sum((Yp-Yo).^2)/sum((Yo-YoMean).^2);
    %Correlation
    x=Ensemble.ENS.TestandValData.Outputs;
    y=Ensemble.ENS.TestandValData.Targets;
    Ensemble.ENS.TestandValData.COR=corr(x',y');

    
    %%%%%%%%%%%%%%%
    %Timeseries
    %%%%%%%%%%%%%%%
    Ensemble.ENS.Timeseries.Response=EnsembleTimeseries;
    Ensemble.ENS.Timeseries.Observed=TData.A; 
      
end


        