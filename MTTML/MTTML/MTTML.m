clc;
clear;
close all;
%%
% Read Data
cd ../Data
[Data ,TData]=LoadData();
cd ../MTTML
%%
%Model Initialization

fid=fopen('Initialization.txt');
tline = fgetl(fid);
j=0;
Vars=cell(1);
while ischar(tline)
    j=j+1;
    Vars{j}=tline;
    tline = fgetl(fid);
end
fclose(fid);

%%
% DFNN Model

% Choosing Optimization Method  
Demand = Vars{1};

if contains(Demand,'SFS')
    disp('SFS')
    cd ../SFS
    FinalNet=SFS(Data,TData,Vars);
elseif contains(Demand,'GA')
    disp('GA')
    cd ../GA
    FinalNet=GA(Data,TData,Vars);
elseif contains(Demand,'PSO')
    disp('PSO')
    cd ../PSO
    FinalNet=PSO(Data,TData,Vars);
end
cd ../MTTML
save('FinalNet.mat','FinalNet');

clearvars ans fid j tline
