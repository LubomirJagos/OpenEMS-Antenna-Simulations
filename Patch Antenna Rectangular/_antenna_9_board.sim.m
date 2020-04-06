addpath('C:\Users\H364387\Downloads\pcb2csx\matlab');
addpath('C:\Users\H364387\Downloads\openems\matlab');

%%% Board mesh, part 1
unit = 1.0e-3;
FDTD = InitFDTD();
% Excitation begin
FDTD = SetGaussExcite(FDTD, 1100000000.000000, 1000000000.000000);
% Excitation end
BC = {'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8'};
FDTD = SetBoundaryCond(FDTD, BC);
physical_constants;
CSX = InitCSX();

run _antenna_9_board.m

Sim_Path = 'tmp9';
Sim_CSX = 'csxcad.xml';
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );
