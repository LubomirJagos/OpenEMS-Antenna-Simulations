addpath('C:\Users\H364387\Downloads\pcb2csx\matlab');
addpath('C:\Users\H364387\Downloads\openems\matlab'); 

%%% Board mesh, part 1
unit = 1.0e-3;
FDTD = InitFDTD();
% Excitation begin
FDTD = SetGaussExcite(FDTD, 0.000000, -2147483648.000000);
% Excitation end
BC = {'MUR' 'MUR' 'MUR' 'MUR' 'MUR' 'MUR'};
FDTD = SetBoundaryCond(FDTD, BC);
physical_constants;
CSX = InitCSX();

run antenna.m

Sim_Path = '.';
Sim_CSX = 'csxcad.xml';
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );
