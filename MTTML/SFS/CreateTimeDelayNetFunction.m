function TimeDelayNetResults=CreateTimeDelayNetFunction(Params,Data,OFN)
    INPUTS=Data.INPUTS;
    TARGETS=Data.TARGETS;
    if ~isempty(Params.HLN)
        % Choose a Training Function
        % For a list of all training functions type: help nntrain
        % 'trainlm' is usually fastest.
        % 'trainbr' takes longer but may be better for challenging problems.
        % 'trainscg' uses less memory. Suitable in low memory situations.
        TrainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
        % Create a Time Delay Network
        InputDelays=Params.TapDelay;
        HiddenLayerSize =Params.HLN;
        Net = timedelaynet(InputDelays,HiddenLayerSize,TrainFcn);

        %Chossing Transfer Function
        %Net.layers{1}.transferFcn = 'tansig';

        % Choose Input and Output Pre/Post-Processing Functions
        % For a list of all processing functions type: help nnprocess
        Net.input.processFcns = {'removeconstantrows','mapminmax'};
        Net.output.processFcns = {'removeconstantrows','mapminmax'};

        % Prepare the Data for Training and Simulation
        % The function PREPARETS prepares timeseries data for a particular network,
        % shifting time by the minimum amount to fill input states and layer
        % states. Using PREPARETS allows you to keep your original time series data
        % unchanged, while easily customizing it for networks with differing
        % numbers of delays, with open loop or closed loop feedback modes.
        [~,xi,ai,~] = preparets(Net,INPUTS,TARGETS);
        [~,is]=size(xi);
        for i = 1 : is 
            xi{1,i}=INPUTS{1,end-is+i};
        end
        x=INPUTS;
        t=TARGETS;
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
        
        
        

        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivision
        Net.divideFcn = 'dividerand';  % Divide data randomly
        Net.divideMode = 'time';  % Divide up every sample
        Net.divideParam.trainRatio = 60/100;
        Net.divideParam.valRatio = 20/100;
        Net.divideParam.testRatio = 20/100;

        % Choose a Performance Function
        % For a list of all performance functions type: help nnperformance
        Net.performFcn = 'mse';  % Mean Squared Error

        % Choose Plot Functions
        % For a list of all plot functions type: help nnplot
        Net.plotFcns = {'plotperform','plottrainstate', 'ploterrhist', ...
            'plotregression', 'plotresponse', 'ploterrcorr', 'plotinerrcorr'};

        Net.trainParam.showWindow=OFN;
        Net.trainParam.showCommandLine=false;
        Net.trainParam.show=1;
        Net.trainParam.epochs=2000;
        Net.trainParam.goal=1e-8;
        Net.trainParam.max_fail=10;

        % Train the Network
        [Net,tr] = train(Net,x,t,xi,ai);

        % Test the Network
        NetOutputs = Net(x,xi,ai);
    else

        t =inf(size(TARGETS));
        NetOutputs = inf(size(TARGETS));
        tr.trainInd=[];
        tr.valInd=[];
        tr.testInd=[];
    end
    %All Data
    AllData.Ind=[tr.trainInd tr.valInd tr.testInd];
    AllData.Ind=sort(AllData.Ind);
    AllData.Targets = t(:,AllData.Ind);
    AllData.Outputs = NetOutputs(:,AllData.Ind);
    AllData.Error = gsubtract(AllData.Targets,AllData.Outputs);
    if ~isempty(Params.HLN)
        AllData.MSE = perform(Net,AllData.Targets,AllData.Outputs);
        AllData.RMSE = sqrt(AllData.MSE);
        AllData.COR = corr(cell2mat(AllData.Targets)',cell2mat(AllData.Outputs)');
        NSEP.Outputs=cell2mat(AllData.Outputs);
        NSEP.Targets=cell2mat(AllData.Targets);
        NSEP.MEANOB=mean(NSEP.Targets(1,:));
        AllData.NSE = 1 - sum((NSEP.Outputs(1,:)-NSEP.Targets(1,:)).^(2))/...
            sum((NSEP.Targets(1,:)-NSEP.MEANOB).^(2));
    else
        AllData.MSE = inf;
        AllData.RMSE = inf;
        AllData.COR = -inf;
        AllData.NSE = -inf;
    end
    %Training Data
    TrainData.Ind = tr.trainInd;
    TrainData.Ind = sort(TrainData.Ind);
    TrainData.Targets = t(:,TrainData.Ind);
    TrainData.Outputs = NetOutputs(:,TrainData.Ind);
    TrainData.Error = gsubtract(TrainData.Targets,TrainData.Outputs);
    if ~isempty(Params.HLN)
    TrainData.MSE = perform(Net,TrainData.Targets,TrainData.Outputs);
    TrainData.RMSE=sqrt(TrainData.MSE);
    TrainData.COR=corr(cell2mat(TrainData.Targets)',cell2mat(TrainData.Outputs)');
    NSEP.Outputs=cell2mat(TrainData.Outputs);
    NSEP.Targets=cell2mat(TrainData.Targets);
    NSEP.MEANOB=mean(NSEP.Targets(1,:));
    TrainData.NSE = 1 - sum((NSEP.Outputs(1,:)-NSEP.Targets(1,:)).^(2))/...
        sum((NSEP.Targets(1,:)-NSEP.MEANOB).^(2));
    else
        TrainData.MSE = inf;
        TrainData.RMSE = inf;
        TrainData.COR = -inf;
        TrainData.NSE = -inf;
    end
    %Vlidation Data
    ValData.Ind = tr.valInd;
    ValData.Ind = sort(ValData.Ind);
    ValData.Targets = t(:,ValData.Ind);
    ValData.Outputs = NetOutputs(:,ValData.Ind);
    ValData.Error = gsubtract(ValData.Targets,ValData.Outputs);
    if ~isempty(Params.HLN)
    ValData.MSE = perform(Net,ValData.Targets,ValData.Outputs);
    ValData.RMSE= sqrt(ValData.MSE);
    ValData.COR= corr(cell2mat(ValData.Targets)',cell2mat(ValData.Outputs)');
    NSEP.Outputs=cell2mat(ValData.Outputs);
    NSEP.Targets=cell2mat(ValData.Targets);
    NSEP.MEANOB=mean(NSEP.Targets(1,:));
    ValData.NSE = 1 - sum((NSEP.Outputs(1,:)-NSEP.Targets(1,:)).^(2))/...
        sum((NSEP.Targets(1,:)-NSEP.MEANOB).^(2));
    else
        ValData.MSE = inf;
        ValData.RMSE = inf;
        ValData.COR = -inf;
        ValData.NSE = -inf;
    end
    %TEST Data
    TestData.Ind=tr.testInd;
    TestData.Targets = t(:,TestData.Ind);
    TestData.Outputs = NetOutputs(:,TestData.Ind);
    TestData.Error = gsubtract(TestData.Targets,TestData.Outputs);
    if ~isempty(Params.HLN)
    TestData.MSE = perform(Net,TestData.Targets,TestData.Outputs);
    TestData.RMSE=sqrt(TestData.MSE);
    TestData.COR=corr(cell2mat(TestData.Targets)',cell2mat(TestData.Outputs)');
    NSEP.Outputs=cell2mat(TestData.Outputs);
    NSEP.Targets=cell2mat(TestData.Targets);
    NSEP.MEANOB=mean(NSEP.Targets(1,:));
    TestData.NSE = 1 - sum((NSEP.Outputs(1,:)-NSEP.Targets(1,:)).^(2))/...
        sum((NSEP.Targets(1,:)-NSEP.MEANOB).^(2));
    else
        TestData.MSE = inf;
        TestData.RMSE = inf;
        TestData.COR = -inf;
        TestData.NSE = -inf;
    end

    %TEST & VALIDATION Data
    TestandValData.Ind = [tr.testInd tr.valInd];
    TestandValData.Ind = sort(TestandValData.Ind);
    TestandValData.Targets = t(:,TestandValData.Ind);
    TestandValData.Outputs = NetOutputs(:,TestandValData.Ind);
    TestandValData.Error = gsubtract(TestandValData.Targets,TestandValData.Outputs);
    if ~isempty(Params.HLN)
    TestandValData.MSE = perform(Net,TestandValData.Targets,TestandValData.Outputs);
    TestandValData.RMSE=sqrt(TestandValData.MSE);
    TestandValData.COR=corr(cell2mat(TestandValData.Targets)',cell2mat(TestandValData.Outputs)');
    NSEP.Outputs=cell2mat(TestandValData.Outputs);
    NSEP.Targets=cell2mat(TestandValData.Targets);
    NSEP.MEANOB=mean(NSEP.Targets(1,:));
    TestandValData.NSE = 1 - sum((NSEP.Outputs(1,:)-NSEP.Targets(1,:)).^(2))/...
            sum((NSEP.Targets(1,:)-NSEP.MEANOB).^(2));
    else
        TestandValData.MSE = inf;
        TestandValData.RMSE = inf;
        TestandValData.COR = -inf;
        TestandValData.NSE = -inf;
    end

    %Export Results
    if ~isempty(Params.HLN)
        TimeDelayNetResults.Net=Net;
    else
        TimeDelayNetResults.Net=[];
    end
    TimeDelayNetResults.Data=Data;
    TimeDelayNetResults.Params=Params;
    TimeDelayNetResults.AllData=AllData;
    TimeDelayNetResults.TrainData=TrainData;
    TimeDelayNetResults.ValData=ValData;
    TimeDelayNetResults.TestData=TestData;
    TimeDelayNetResults.TestandValData=TestandValData;

end