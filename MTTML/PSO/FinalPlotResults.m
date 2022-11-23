function FinalPlotResults(Results,Data,TData)
    %View Network
    view(Results.Net);

    %Regression Plot
    TrainTargets=Results.TrainData.Targets;
    TrainOutputs=Results.TrainData.Outputs;

    ValTargets=Results.ValData.Targets;
    ValOutputs=Results.ValData.Outputs;

    TestTargets=Results.TestData.Targets;
    TestOutputs=Results.TestData.Outputs;

    AllTargets=Results.AllData.Targets;
    AllOutputs=Results.AllData.Outputs;
    % Four Plots
    figure;
    plotregression(TrainTargets,TrainOutputs,'Train Data',...
         ValTargets,ValOutputs,'Validation Data',...
         TestTargets,TestOutputs,'Test Data',...
         AllTargets,AllOutputs,'All Data');
    set(gca,'FontSize',14);
    
    %All In ONE Regression Plot
    
    %Turning Cell To Matrix
    
    %All Data
    alltargets=cell2mat(AllTargets);
    alloutputs= cell2mat(AllOutputs);
    
    %Training Data
    traintargets=cell2mat(TrainTargets);
    trainoutputs= cell2mat(TrainOutputs);
    
    %validation Data
    valtargets=cell2mat(ValTargets);
    valoutputs= cell2mat(ValOutputs);
    
    %Test Data
    testtargets=cell2mat(TestTargets);
    testoutputs= cell2mat(TestOutputs);
    
    %Regression Plot
    figure;
    xmin=min(min(alltargets),min(alloutputs));
    xmax=max(max(alltargets),max(alloutputs));
    plot([xmin xmax],[xmin xmax],'k','LineWidth',2);
    hold on
    plot(traintargets,trainoutputs,'co','MarkerSize',5,'LineWidth',2);
    hold on;
    plot(valtargets,valoutputs,'mo','MarkerSize',5,'LineWidth',2);
    hold on;
    plot(testtargets,testoutputs,'go','MarkerSize',5,'LineWidth',2);
    hold off;
    R=corr(alltargets',alloutputs');
    title(['Regression Of All Data, R = ' num2str(R)]);
    legend('Reference-Line','Training-Data','Validation-Data','Test-Data');
    xlabel('MTTD-Target [Day]','fontname','Helvetica');
    ylabel('MTTD-NetResponse [Day]','fontname','Helvetica');
    set(gca,'FontSize',14);
    
    %Time Series Plot
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
    %Time Series
    figure;
    plot(Response(1,:),Response(2,:),'r','linewidth',2);
    hold on;
    plot(TData.A(1,:),TData.A(2,:),'b','linewidth',2);
    hold off
    legend('Net-Response','Targets');
    title(['Exact Response', 'RMSE= ' num2str(round(Results.TestandValData.RMSE))],'fontname','Helvetica');
    xlabel('Time [Day]','fontname','Helvetica');
    ylabel('MTTD [Day]','fontname','Helvetica');
    xlim([0 365]);
    set(gca,'FontSize',14);
end