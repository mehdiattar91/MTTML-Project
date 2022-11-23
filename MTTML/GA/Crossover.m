function [y1, y2]=Crossover(x1,x2,gamma,VarMin,VarMax)

    alpha=unifrnd(-gamma,1+gamma,size(x1));
    
    y1=alpha.*x1+(1-alpha).*x2;
    y2=alpha.*x2+(1-alpha).*x1;
    
    %Hidden Layer Number
    y1(1)=max(y1(1),VarMin.L);
    y1(1)=min(y1(1),VarMax.L);
    
    y2(1)=max(y2(1),VarMin.L);
    y2(1)=min(y2(1),VarMax.L);
    
    %Tap Delay
    y1(2)=max(y1(2),VarMin.T);
    y1(2)=min(y1(2),VarMax.T);
    
    y2(2)=max(y2(2),VarMin.T);
    y2(2)=min(y2(2),VarMax.T);

    %Hidden Layer Neurons
    y1(3:end)=max(y1(3:end),VarMin.N);
    y1(3:end)=min(y1(3:end),VarMax.N);
    
    y2(3:end)=max(y2(3:end),VarMin.N);
    y2(3:end)=min(y2(3:end),VarMax.N);

end