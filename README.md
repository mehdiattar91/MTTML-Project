# MTTML-Project
# ParFlow-CLM
ParFlow is an open-source, modular, parallel watershed flow model. It includes fully-integrated overland flow, the ability to simulate complex topography, geology, heterogeneity, and coupled land-surface processes including the land-energy budget, biogeochemistry and snow (via CLM). It is multi-platform and runs with a common I/O structure from laptop to supercomputer. ParFlow is the result of a long, multi-institutional development history and is now a collaborative effort between CSM, LLNL, UniBonn, and UCB. ParFlow has been coupled to the mesoscale, meteorological code ARPS, and NCAR code WRF. See the following reference for an overview of the major features and capabilities:
Kuffour, B. N., Engdahl, N. B., Woodward, C. S., Condon, L. E., Kollet, S., & Maxwell, R. M. (2020). Simulating coupled surface–subsurface flows with ParFlow v3. 5.0: capabilities, applications, and ongoing development of an open-source, massively parallel, integrated hydrologic model. Geoscientific Model Development, 13(3), 1373-1397.
An online version of the user manual is also available on Read the Docks: Parflow User’s Manual. The manual contains additional documentation on how to use ParFlow and set up input files. 
# EcoSLIM
EcoSLIM is a Lagrangian, particle-tracking model that simulates the advective and diffusive movement of water parcels. This code can be used to simulate age, diagnose travel times, source water composition, and flow paths. It integrates seamlessly with ParFlow-CLM. EcoSLIM is the result of a collaboration between Reed Maxwell, Laura Condon, Mohmmad Danesh-Yazdi, and Lindsay Bearup. See the following reference for further details:\ 
Maxwell, R.M., Condon, L.E., Danesh-Yazdi, M., Bearup, L.A., 2019. Exploring source water mixing and transient residence time distributions of outflow and evapotranspiration with an integrated hydrologic model and Lagrangian particle tracking approach: Source water mixing and transient residence time distributions ET and Q. Ecohydrology, doi: 10.1002/eco.2042, 2018.
# MTTML
MTTML is a machine learning model based on Dynamic Feedforward Neural Network (DFNN). The model’s objective is to predict the Median Travel Time (MTT) in hydrological systems. The model uses different combinations of water balance variables, i.e., precipitation, streamflow, evapotranspiration, and water storage, to predict MTT. The model is further capable of deploying three optimization methods, that is, SFS, PSO, and GA, to find the optimal DFNN architecture.\
Use MATLAB 2018 or above to build MTTML. Users should not change the Directory Paths. The inputs of the MTTML model are:
1.	MTTML directory includes the main MTTML file in .m format and the “Initialization.txt” file where the model parameters are initialized in.
2.	ParFlow-CLM input files: The input data must be in a MATLAB structure named “Data.mat”. The arrangement of this structure is:
    -	D.INPUTS: This file is the input of the DFNN model, which is a cell array of the sets of normalized water balance variables. For instance, if C1, C2, and C3 are three water-balance variables, D.INPUTS contains {{[C1(1); C2(1); C3(1)], [C1(2); C2(2); C3(2)], …, [C1(t); C2(t); C3(t)]}.
    -	D.TARGETS: This variable is the cell array of a watershed’s MTT time series that NaN values are omitted from it.
    -	D.MTT: This variable is the vector array of the actual watershed’s MTT time series that includes NaN values.
3.  The “Initialization.txt” file contains the required initializations for the MTTML model. In summary,
    -    Optimization Method: ‘SFS’, ‘GA’, or ‘PSO’.
    -	 SFS Optimization Parameters: SFS optimization method is merely used for DFNN’s with one hidden layer.\
         ⁃	DFNN Ensemble Number: Number of DFNNs that are ensembled with each other.\
         ⁃	DFNN’s Tapped Delay Block: Maximum tapped Delay block in the DFNN.\
         ⁃	DFNN’s Hidden Layer Neuron: Maximum number of neurons in the hidden layer.
    -	 GA Optimization Parameters: Genetic optimization model with multiple hidden layers.\
         ⁃	DFNN Ensemble Number: Number of DFNN’s that are ensembled with each other.\
         ⁃	DFNN Hidden Layers: Maximum number of hidden layers in the DFNN.\
         ⁃	DFNN’s Tapped Delay Block: Maximum tapped Delay block in the DFNN.\
         ⁃	DFNN’s Hidden Layer Neuron: Maximum number of neurons in each hidden layer.\
         ⁃	Iteration Number: GA’s maximum number of iterations.\
         ⁃	Population Number: Number of DFNNs that are generated as the initial population of PSO.\ 
         ⁃	Crossover Percentage: The percentage of the population that is recombined with each other in each iteration.\
         ⁃	Mutation Percentage: The percentage of the population that is mutated in each iteration.\
         ⁃ 	Mutation Rate: The percentage of the DFNN’s features that are mutated.
         ⁃	Selection Pressure: This Parameter is the selection pressure factor of Boltzmann selection.
    -	 PSO Optimization Parameters: PSO optimization model with multiple hidden layers.\
         ⁃	DFNN Ensemble Number: Number of DFNNs that are ensembled with each other.\
         ⁃	DFNN Hidden Layers: Maximum number of hidden layers in the DFNN.\
         ⁃	DFNN’s Tapped Delay Block: Maximum tapped Delay block of the DFNN.\
         ⁃	DFNN’s Hidden Layer Neuron: Maximum number of neurons in each hidden layer.\
         ⁃	Iteration Number: Maximum number of iterations.\
         ⁃	Population Number: Number of DFNNs that are generated as the initial population of PSO. 
Example:\
'SFS'        % Choose the Optimization Method\
% SFS-Initialization\
50           % DFNN Ensemble Number\
30           % Max Tap Delay Block\
50           % Max Number of Neurons in the Hidden Layers\
% GA-Initialization\
50           % DFNN Ensemble Number\
3            % Max Number of Hidden Layers\
30           % Max Tap Delay Block\
50           % Max Number of Neurons in the Layers\
100          % Maximum Number of Iterations\
100          % Population Size\
0.8          % Crossover Percentage\
0.3          % Mutation Percentage\
0.2          % Mutation Rate\
10           % Selection Pressure\
% PSO-Initialization\
50           % DFNN Ensemble Number\
3            % Max Number of Hidden Layers\
30           % Max Tap Delay Block\
50           % Max Number of Neurons in the Layers\
100          % Maximum Number of Iterations\
100          % Population Size\

