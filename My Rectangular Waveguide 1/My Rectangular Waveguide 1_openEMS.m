% EXAMPLE / generated file for openEMS from FreeCAD
%
% This is generated file
%
% FreeCAD to OpenEMS plugin by Lubomir Jagos
%

close all
clear
clc

%% switches & options...
postprocessing_only = 1;
draw_3d_pattern = 0; % this may take a while...
use_pml = 0;         % use pml boundaries instead of mur

currDir = strrep(pwd(), '\', '\\');

%LuboJ, JUST TO SEE RESULT
%openEMS_opts = '--no-simulation';
%openEMS_opts = '--debug-PEC --no-simulation';
openEMS_opts = '';

%% setup the simulation
physical_constants;

%% prepare simulation folder
Sim_Path = 'tmp';
Sim_CSX = 'My Rectangular Waveguide 1.xml';
[status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
[status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder

%% setup FDTD parameter & excitation function
max_timesteps = 20000;
min_decrement = 0.0005; % equivalent to -50 dB
FDTD = InitFDTD( 'NrTS', max_timesteps, 'EndCriteria', min_decrement );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [];
mesh.y = [];
mesh.z = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXCITATION in excitation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f0 = 1000000000.0*1;
fc = 1500000000.0;
FDTD = SetGaussExcite(FDTD, f0, fc );
BC = {'MUR' 'MUR' 'MUR' 'MUR' 'MUR' 'MUR'}; % boundary conditions
if (use_pml>0)
    BC = {'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8'}; % use pml instead of mur
end
FDTD = SetBoundaryCond( FDTD, BC );

CSX = InitCSX();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORT - Et_ - YZ plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = AddDump( CSX, 'Et_', 'DumpType', 0, 'DumpMode', 2);
dumpStart = [0.0, -43.849834, 0.0];
dumpStop = [0.0, 44.23683200000001, 421.648773];
CSX = AddBox( CSX, 'Et_', 0, dumpStart, dumpStop );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORT - Et_ - XZ plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = AddDump( CSX, 'Et_2', 'DumpType', 0, 'DumpMode', 2);
dumpStart = [-50.113082999999996, 0.0, 0.0];
dumpStop = [50.75829699999999, 9.329128047852465e-14, 420.1465759999999];
CSX = AddBox( CSX, 'Et_2', 0, dumpStart, dumpStop );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORT - input - excitation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
portStart = [-43.917751, -33.682266, 0.0];
portStop = [45.227196, 33.441742000000005, 5.0];
portR = 0;
portUnits = 0.01;
portDirection = [0.0 0.0 1.0];
[CSX port{1}] = AddLumpedPort(CSX, 5, 1, portR*portUnits, portStart, portStop, portDirection);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH - air - simbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [mesh.x (-80.00000000000016:7.0:80.0000000000001) + 0];
mesh.y = [mesh.y (-375.78704799999997:7.0:396.90298500000006) + 0];
mesh.z = [mesh.z (-115.511269:7.0:595.4161379999999) + 0];
CSX = DefineRectGrid(CSX, 0.01, mesh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH - metal - wall_1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [mesh.x (-43.749607:0.5:-39.83704) + 0];
mesh.y = [mesh.y (-35.657707:0.5:34.946335) + 0];
mesh.z = [mesh.z (0.0:0.5:420.0) + 0];
CSX = DefineRectGrid(CSX, 0.01, mesh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH - metal - wall_2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [mesh.x (-44.105293:0.5:46.417271) + 0];
mesh.y = [mesh.y (-34.234955:0.5:-30.322388) + 0];
mesh.z = [mesh.z (0.0:0.5:420.0) + 0];
CSX = DefineRectGrid(CSX, 0.01, mesh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH - metal - wall_3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [mesh.x (40.014881:0.5:44.816669) + 0];
mesh.y = [mesh.y (-36.013397:0.5:36.01339300000001) + 0];
mesh.z = [mesh.z (0.0:0.5:420.0) + 0];
CSX = DefineRectGrid(CSX, 0.01, mesh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH - metal - wall_4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = [mesh.x (-46.061581:0.5:46.417271) + 0];
mesh.y = [mesh.y (29.78886:0.5:34.412804) + 0];
mesh.z = [mesh.z (0.0:0.5:420.0) + 0];
CSX = DefineRectGrid(CSX, 0.01, mesh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATERIAL - metal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = AddMetal( CSX, 'metal' );
CSX = ImportSTL(CSX, 'metal',10, [currDir '/wall_4_gen_model.stl'],'Transform',{'Scale', 1});
CSX = ImportSTL(CSX, 'metal',10, [currDir '/wall_1_gen_model.stl'],'Transform',{'Scale', 1});
CSX = ImportSTL(CSX, 'metal',10, [currDir '/wall_2_gen_model.stl'],'Transform',{'Scale', 1});
CSX = ImportSTL(CSX, 'metal',10, [currDir '/wall_3_gen_model.stl'],'Transform',{'Scale', 1});
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );
CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

if (postprocessing_only==0)
    %% run openEMS
    RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts );
end
