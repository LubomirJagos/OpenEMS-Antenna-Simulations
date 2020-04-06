addpath('C:\Users\H364387\Downloads\pcb2csx\matlab');
addpath('C:\Users\H364387\Downloads\openems\matlab');

%%% Board mesh, part 1
unit = 1.0e-3;
FDTD = InitFDTD();
% Excitation begin
FDTD = SetGaussExcite(FDTD, 0.000000, 1.000000);
% Excitation end
BC = {'PEC' 'PEC' 'PEC' 'PEC' 'PEC' 'PEC'};
FDTD = SetBoundaryCond(FDTD, BC);
physical_constants;
CSX = InitCSX();

run "C:/Users/H364387/Documents/KiCad/Patch Antenna Circular Polarization/PcbRndPatch ANtenna Circular Polariyation Design.m"

Sim_Path = '.';
Sim_CSX = 'csxcad.xml';
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts );
