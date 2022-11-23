function [Data, TData]=LoadData()

   F=load('Data.mat');
   %Net Training Data
   Data.INPUTS=F.D.INPUTS;
   Data.TARGETS=F.D.TARGETS;
   %PlotData
   %Actual MTT
   TData.A=F.D.MTT;
   % NAN Omitted MTT 
   [~,s]=size(TData.A);
   j=0;
   R=zeros(2,2);
   for i = 1:s
       if ~isnan(TData.A(2,i))
           j=j+1;
           R(1,j)=i;
           R(2,j)=TData.A(2,i);
       end
   end
   TData.R=R;
   
end