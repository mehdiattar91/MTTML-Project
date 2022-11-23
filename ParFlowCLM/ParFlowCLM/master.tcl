### ParFlowCLM ###

#set tcl_precision 17
set runname "HYP"

#---------------------------------------------------------
# Import the ParFlow TCL package
#---------------------------------------------------------

lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*

#-----------------------------------------------------------------------------
# Make a directory for the simulation run, files will be copied to this
# directory for running.
#-----------------------------------------------------------------------------
file mkdir "Outputs"
cd "./Outputs"

pfset FileVersion 4

#---------------------------------------------------------
# Process Topology -- Sets the parallel process topology - P*Q*R must equal nodes*ntasks per node
#---------------------------------------------------------
# DX 
pfset Process.Topology.P        1
# DY
pfset Process.Topology.Q        1
# DZ - usually leave as one processor, don't want to split up dz
pfset Process.Topology.R        1



#--------------------------------------------------------------
# Starting the model
# -------------------------------------------------------------
#set runlength 8760
#set startcount 0
#set starttime 0
#set stoptime $runlength

#--------------------------------------------------------------
# Restarting the model
# -------------------------------------------------------------
#set lastpress 8064
#puts "last pressure file = $lastpress"
#set ip [format ./Base.out.press.%05d.pfb $lastpress]
#puts "$ip"
#   file copy -force $ip ./press.init.pfb

#set istep    [expr $lastpress+1]
#set startcount $lastpress
#set starttime  $lastpress
#set stoptime   $runlength

#-----------------------------------------------------------------------------
# Make a directory for the simulation and copy inputs into it
#-----------------------------------------------------------------------------
#exec mkdir "Outputs"
#cd "./Outputs"

#CLM Inputs
file copy -force "../drv_clmin.dat"  .
file copy -force "../drv_vegp.dat"  .
file copy -force "../drv_vegm.dat"  .

#puts "Files Copied"

#---------------------------------------------------------
# Computational Grid
#---------------------------------------------------------

# Locate the origin
pfset ComputationalGrid.Lower.X           0.0
pfset ComputationalGrid.Lower.Y           0.0
pfset ComputationalGrid.Lower.Z           0.0

# Define the number of grid blocks in domain
pfset ComputationalGrid.NX               100
pfset ComputationalGrid.NY               5
pfset ComputationalGrid.NZ               20

# Define size of domain grid -- length units equals hydraulic conductivity -- m/h
pfset ComputationalGrid.DX		1
pfset ComputationalGrid.DY		0.2
pfset ComputationalGrid.DZ		0.47     
#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------

pfset GeomInput.Names                 	"domain_input"
pfset GeomInput.domain_input.GeomName  		domain
pfset GeomInput.domain_input.InputType  	Box


#---------------------------------------------------------
# Domain Geometry 
#---------------------------------------------------------
pfset Geom.domain.Lower.X                        0.0
pfset Geom.domain.Lower.Y                        0.0
pfset Geom.domain.Lower.Z                        0.0
 
pfset Geom.domain.Upper.X                        100.0
pfset Geom.domain.Upper.Y                        1.0
pfset Geom.domain.Upper.Z                        9.4
pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"


#--------------------------------------------------------------------------------
#dz Multipliers
#--------------------------------------------------------------------------------
pfset Slover.Nonlinear.VariableDz                True
pfset dzScale.GeomNames                          domain
pfset dzScale.Type                               nzlist
pfset dzScale.nzlistNumber                       20
pfset Cell.0.dzScale.Value                       1.06383
pfset Cell.1.dzScale.Value                       1.06383
pfset Cell.2.dzScale.Value                       1.06383
pfset Cell.3.dzScale.Value                       1.06383
pfset Cell.4.dzScale.Value                       1.06383
pfset Cell.5.dzScale.Value                       1.06383
pfset Cell.6.dzScale.Value                       1.06383
pfset Cell.7.dzScale.Value                       1.06383
pfset Cell.8.dzScale.Value                       1.06383
pfset Cell.9.dzScale.Value                       1.06383
pfset Cell.10.dzScale.Value                      1.06383
pfset Cell.11.dzScale.Value                      1.06383
pfset Cell.12.dzScale.Value                      1.06383
pfset Cell.13.dzScale.Value                      1.06383
pfset Cell.14.dzScale.Value                      1.06383
pfset Cell.15.dzScale.Value                      1.06383
pfset Cell.16.dzScale.Value                      1.06383
pfset Cell.17.dzScale.Value                      1.06383
pfset Cell.18.dzScale.Value                      0.6383
pfset Cell.19.dzScale.Value                      0.212766
#-----------------------------------------------------------------------------
# Perm -- Ksat is what is specified here -- m/h units
#-----------------------------------------------------------------------------

pfset Geom.Perm.Names                  "domain"

pfset Geom.domain.Perm.Type		Constant
pfset Geom.domain.Perm.Value		0.05

#-----------------------------------------------------------------------------
# Permeability Tensors
#-----------------------------------------------------------------------------

pfset Perm.TensorType			TensorByGeom
pfset Geom.Perm.TensorByGeom.Names	"domain"
pfset Geom.domain.Perm.TensorValX  	1.0d0
pfset Geom.domain.Perm.TensorValY  	1.0d0
pfset Geom.domain.Perm.TensorValZ  	1.0d0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type			Constant
pfset SpecificStorage.GeomNames			"domain"
pfset Geom.domain.SpecificStorage.Value 	1.0e-4


#-----------------------------------------------------------------------------
# Phases  -- Setting to 1.0 allows for the calculation of K instead of k
#-----------------------------------------------------------------------------

pfset Phase.Names				"water"
pfset Phase.water.Density.Type	      	 	 Constant
pfset Phase.water.Density.Value	       		 1.0

pfset Phase.water.Viscosity.Type		Constant
pfset Phase.water.Viscosity.Value		1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------

pfset Contaminants.Names		""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------

pfset Geom.Retardation.GeomNames	""

#-----------------------------------------------------------------------------
# Gravity  -- Setting to 1.0 allows for the calculation of K instead of k
#-----------------------------------------------------------------------------

pfset Gravity				1.0

#-----------------------------------------------------------------------------
# Setup timing info -- units set by permeability -- m/h
#-----------------------------------------------------------------------------

# Base unit of time for all time values entered. All time should be expressed as multiples of this value.  Perm = m/hr, base unit = hr
pfset TimingInfo.BaseUnit        1.0
pfset TimingInfo.StartCount      0.0 
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime        43800.0

# Interval in which output files will be written
pfset TimingInfo.DumpInterval    1.0

#Setup time step type and value
pfset TimeStep.Type              Constant
pfset TimeStep.Value             1

#-----------------------------------------------------------------------------
# Porosity -- Assign for soil units, geologic units will receive domain porosity
#-----------------------------------------------------------------------------

pfset Geom.Porosity.GeomNames		"domain"

pfset Geom.domain.Porosity.Type		Constant
pfset Geom.domain.Porosity.Value	0.2

#-----------------------------------------------------------------------------
# Domain -- Report/Upload the domain problem that is defined above
#-----------------------------------------------------------------------------

pfset Domain.GeomName			"domain"


#-----------------------------------------------------------------------------
# Mobility -- Mobility between phases -- Only one phase in this problem
#-----------------------------------------------------------------------------

pfset Phase.water.Mobility.Type		Constant
pfset Phase.water.Mobility.Value	1.0

#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names                         ""


#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------

pfset Cycle.Names 				"Constant"
pfset Cycle.Constant.Names			"alltime"
pfset Cycle.Constant.alltime.Length    		 1
pfset Cycle.Constant.Repeat           		  -1
 
#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------

pfset BCPressure.PatchNames                   [pfget Geom.domain.Patches]

pfset Patch.x-lower.BCPressure.Type		      FluxConst
pfset Patch.x-lower.BCPressure.Cycle		      "Constant"
pfset Patch.x-lower.BCPressure.alltime.Value	      0.0

pfset Patch.y-lower.BCPressure.Type		      FluxConst
pfset Patch.y-lower.BCPressure.Cycle		      "Constant"
pfset Patch.y-lower.BCPressure.alltime.Value	      0.0

pfset Patch.z-lower.BCPressure.Type		      FluxConst
pfset Patch.z-lower.BCPressure.Cycle		      "Constant"  
pfset Patch.z-lower.BCPressure.alltime.Value	       0.0 

pfset Patch.x-upper.BCPressure.Type		      FluxConst
pfset Patch.x-upper.BCPressure.Cycle		      "Constant"
pfset Patch.x-upper.BCPressure.alltime.Value	      0.0

pfset Patch.y-upper.BCPressure.Type		      FluxConst
pfset Patch.y-upper.BCPressure.Cycle		      "Constant"
pfset Patch.y-upper.BCPressure.alltime.Value	      0.0

pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "Constant"  
pfset Patch.z-upper.BCPressure.alltime.Value		0.0


#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------

pfset TopoSlopesX.Type 			"Constant"
pfset TopoSlopesX.GeomNames	 	"domain"
pfset TopoSlopesX.Geom.domain.Value	-0.1

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------

pfset TopoSlopesY.Type 			"Constant"
pfset TopoSlopesY.GeomNames		"domain"
pfset TopoSlopesY.Geom.domain.Value  	0.0

#---------------------------------------------------------
# Mannings Coefficient
#---------------------------------------------------------
pfset Mannings.Type		"Constant"
pfset Mannings.GeomNames	"domain"
pfset Mannings.Geom.domain.Value 1.0e-6

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type                  VanGenuchten
pfset Phase.RelPerm.GeomNames             "domain"

pfset Geom.domain.RelPerm.Alpha           1.0
pfset Geom.domain.RelPerm.N               2.0

#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type               VanGenuchten
pfset Phase.Saturation.GeomNames          "domain"

pfset Geom.domain.Saturation.Alpha        1.0
pfset Geom.domain.Saturation.N            2.0
pfset Geom.domain.Saturation.SRes         0.01
pfset Geom.domain.Saturation.SSat         1.0

#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.water.Type				"Constant"
pfset PhaseSources.water.GeomNames			"domain"
pfset PhaseSources.water.Geom.domain.Value		0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution

#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

pfset Solver						Richards
pfset Solver.MaxIter					1000000000

pfset Solver.TerrainFollowingGrid			True

pfset Solver.Nonlinear.MaxIter				1500
pfset Solver.Nonlinear.ResidualTol			0.00001
pfset Solver.Nonlinear.EtaValue				0.001

pfset Solver.PrintSubsurf				False
pfset Solver.Drop					1E-15
pfset Solver.AbsTol					1E-9
pfset Solver.MaxConvergenceFailures			7

pfset Solver.Nonlinear.UseJacobian			True 
pfset Solver.Nonlinear.StepTol				1e-19
pfset Solver.Nonlinear.AbsTol				1e-9

pfset Solver.Linear.MaxIter				15000
pfset Solver.Nonlinear.Globalization			LineSearch
pfset Solver.Linear.KrylovDimension			150
pfset Solver.Linear.MaxRestarts				6

pfset Solver.Linear.Preconditioner			PFMG
pfset Solver.Linear.Preconditioner.PCMatrixType		FullJacobian

pfset Solver.WriteSiloSubsurfData			 True
pfset Solver.WriteSiloPressure				 True
pfset Solver.WriteSiloSaturation			 True

#Using kinematic wave
#pfset OverlandFlowDiffusive				1

#-----------------------------------------------------------------------------
#CLM: setup
#-----------------------------------------------------------------------------
 pfset Solver.LSM                                      CLM
 pfset Solver.CLM.CLMFileDir                           "clm_output/"
 pfset Solver.CLM.Print1dOut                           False
 pfset Solver.BinaryOutDir                             False
 pfset Solver.CLM.CLMDumpInterval                      1
# 
 pfset Solver.CLM.EvapBeta                             Linear
 pfset Solver.CLM.VegWaterStress                       Saturation
 pfset Solver.CLM.ResSat                               0.01
 pfset Solver.CLM.WiltingPoint                         0.2
 pfset Solver.CLM.FieldCapacity                        1.00

# 
# #Met forcing and timestep setup
 pfset Solver.CLM.MetForcing                            1D
 pfset Solver.CLM.MetFileName				ParFlowData.txt
 pfset Solver.CLM.MetFilePath			        "../"
 pfset Solver.CLM.MetFileNT                            	1
 pfset Solver.CLM.IstepStart                           	1
 pfset solver.CLM.ReuseCount                            1
# 
# #Irrigation setup
 pfset Solver.CLM.IrrigationType			none
 pfset Solver.CLM.ForceVegetation			False

 pfset Solver.CLM.ReuseCount                            1
 pfset Solver.CLM.RootZoneNZ                         	7
 pfset Solver.CLM.SoiLayer                              2
 pfset Solver.CLM.WriteLogs                             False
 pfset Solver.CLM.WriteLastRST                          True
 pfset Solver.CLM.DailyRST                      	True

#-----------------------------------------------------------------------------
#Writing Outputs
#-----------------------------------------------------------------------------
#Writing output:
pfset Solver.PrintSubsurfData				True
pfset Solver.PrintPressure				True
pfset Solver.PrintVelocities                            True
pfset Solver.PrintSaturation			        True
pfset Solver.WriteCLMBinary				False
pfset Solver.PrintCLM					True
pfset Solver.PrintLSMSink                               False
pfset Solver.CLM.SingleFile                             True
pfset Solver.PrintEvapTrans                             True

pfset Solver.WriteSiloSpecificStorage                   False
pfset Solver.WriteSiloMannings                          False
pfset Solver.WriteSiloMask                              False
pfset Solver.WriteSiloSlopes                            False
pfset Solver.WriteSiloSubsurfData                       False
pfset Solver.WriteSiloPressure                          False
pfset Solver.WriteSiloSaturation                        False
pfset Solver.WriteSiloEvapTrans                         False
pfset Solver.WriteSiloEvapTransSum                      False
pfset Solver.WriteSiloOverlandBCFlux                    False
pfset Solver.WriteSiloVelocities                        False
pfset Solver.WriteSiloCLM                               False

#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

# Restart from previous pressure file
pfset ICPressure.Type					HydroStaticPatch
pfset ICPressure.GeomNames				"domain"
pfset Geom.domain.ICPressure.Value 			-3.0
pfset Geom.domain.ICPressure.RefGeom                    domain
pfset Geom.domain.ICPressure.RefPatch                   z-upper


#-----------------------------------------------------------------------------
# Run Simulation
#-----------------------------------------------------------------------------
pfrun $runname

#-----------------------------------------------------------------------------
# Undistribute outputs
#-----------------------------------------------------------------------------
pfundist $runname
puts "ParFlow run Complete"


