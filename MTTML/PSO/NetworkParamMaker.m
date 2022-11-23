function Params=NetworkParamMaker(SelectedFeatures)
    TD=SelectedFeatures(2);
    %TapDelay
    if TD ==0
        Params.TapDelay=0;
    else
        Params.TapDelay=1:TD;
    end
    %HLN
    LayerNumber=SelectedFeatures(1);
    NeuronNumber=SelectedFeatures(3:end);
    Params.HLN=NeuronNumber(1:LayerNumber);
end