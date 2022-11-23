function y=Mutate(x,mu,VarMin,VarMax)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
    j=j';
    
    %Hidden Layer Number sigma
    sigma.L=0.1*(VarMax.L-VarMin.L);
    
    %Tap Delay sigma
    sigma.T=0.1*(VarMax.T-VarMin.T);
    
    %Hidden Layer Neuron sigma
    sigma.N=0.1*(VarMax.N-VarMin.N);
    
    %Mutation
    y=x;
    
    for i=j
        if i == 1 %Layer Number
            y(i)=x(i)+sigma.L*randn(1)';
        elseif i == 2 %Tap Delay
            y(i)=x(i)+sigma.T*randn(1)';
        elseif i > 2  %Neuron
            y(i)=x(i)+sigma.N*randn(1)';
        end
    end
    
    %Hidden Layer Number
    y(1)=max(y(1),VarMin.L);
    y(1)=min(y(1),VarMax.L);
    
    %Tap Delay
    y(2)=max(y(2),VarMin.T);
    y(2)=min(y(2),VarMax.T);
    
    %Hidden Layer Neuron
    y(3:end)=max(y(3:end),VarMin.N);
    y(3:end)=min(y(3:end),VarMax.N);

end