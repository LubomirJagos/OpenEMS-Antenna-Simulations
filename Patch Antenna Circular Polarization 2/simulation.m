%
% EXAMPLE / circular polarized patch antenna
%
% This example demonstrates how to:
%  - calculate the reflection coefficient of a circular polarized patch antenna
%
% 2020 Lubomir Jagos

close all
clear
clc

%% switches & options...
postprocessing_only = 0;
draw_3d_pattern = 0; % this may take a while...
use_pml = 0;         % use pml boundaries instead of mur

%LuboJ, JUST TO SEE RESULT
%openEMS_opts = '--no-simulation';
openEMS_opts = '';

%% setup the simulation
physical_constants;
unit = 1e-3; % all length in mm

% width in x-direction
% length in y-direction
% main radiation in z-direction
patch.width  = 21.0; % resonant length
patch.length = 35.1;

substrate.epsR   = 3.6;
substrate.kappa  = 1e-3 * 2*pi*2.45e9 * EPS0*substrate.epsR;
substrate.width  = 80;
substrate.length = 80;
substrate.thickness = 1.5;
substrate.cells = 4;

feed.posX = 4.72;
feed.posY = -17.043985;
feed.width = 1;
feed.R = 206; % feed resistance

% size of the simulation box
SimBox = [100 100 25];

%% prepare simulation folder
Sim_Path = 'tmp';
Sim_CSX = 'patch_ant.xml';
if (postprocessing_only==0)
    [status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
    [status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder
end

%% setup FDTD parameter & excitation function
max_timesteps = 8e6;
min_decrement = 1e-5; % equivalent to -50 dB
f0 = 4e9; % center frequency
fc = 8e9; % 20 dB corner frequency
FDTD = InitFDTD( 'NrTS', max_timesteps, 'EndCriteria', min_decrement );

%FDTD = SetGaussExcite( FDTD, f0, fc );
FDTD = SetSinusExcite(FDTD,f0); %LuboJ try sinus excitation

BC = {'MUR' 'MUR' 'MUR' 'MUR' 'MUR' 'MUR'}; % boundary conditions
if (use_pml>0)
    BC = {'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8'}; % use pml instead of mur
end
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh
% currently, openEMS cannot automatically generate a mesh
max_res = c0 / (f0+fc) / unit / 20; % cell size: lambda/20

CSX = InitCSX();


%mesh.x = [-SimBox(1)/2 SimBox(1)/2 -substrate.width/2 substrate.width/2 feed.pos];
%% add patch mesh with 2/3 - 1/3 rule
%mesh.x = [mesh.x -patch.width/2-max_res/2*0.66 -patch.width/2+max_res/2*0.33 patch.width/2+max_res/2*0.66 patch.width/2-max_res/2*0.33];
%mesh.x = SmoothMeshLines( mesh.x, max_res, 1.4); % create a smooth mesh between specified mesh lines
%mesh.y = [-SimBox(2)/2 SimBox(2)/2 -substrate.length/2 substrate.length/2 -feed.width/2 feed.width/2];
%% add patch mesh with 2/3 - 1/3 rule
%mesh.y = [mesh.y -patch.length/2-max_res/2*0.66 -patch.length/2+max_res/2*0.33 patch.length/2+max_res/2*0.66 patch.length/2-max_res/2*0.33];
%mesh.y = SmoothMeshLines( mesh.y, max_res, 1.4 );
%mesh.z = [-SimBox(3)/2 linspace(0,substrate.thickness,substrate.cells) SimBox(3) ];
%mesh.z = SmoothMeshLines( mesh.z, max_res, 1.4 );
%mesh = AddPML( mesh, [8 8 8 8 8 8] ); % add equidistant cells (air around the structure)
%CSX = DefineRectGrid( CSX, unit, mesh );

%% create patch
%CSX = AddMetal( CSX, 'patch' ); % create a perfect electric conductor (PEC)
%start = [-patch.width/2 -patch.length/2 substrate.thickness];
%stop  = [ patch.width/2  patch.length/2 substrate.thickness];
%CSX = AddBox(CSX,'patch',10,start,stop);

%% create substrate
%CSX = AddMaterial( CSX, 'substrate' );
%CSX = SetMaterialProperty( CSX, 'substrate', 'Epsilon', substrate.epsR, 'Kappa', substrate.kappa );
%start = [-substrate.width/2 -substrate.length/2 0];
%stop  = [ substrate.width/2  substrate.length/2 substrate.thickness];
%CSX = AddBox( CSX, 'substrate', 0, start, stop );

%% create ground (same size as substrate)
%CSX = AddMetal( CSX, 'gnd' ); % create a perfect electric conductor (PEC)
%start(3)=0;
%stop(3) =0;
%CSX = AddBox(CSX,'gnd',10,start,stop);

%% apply the excitation & resist as a current source
%start = [feed.pos-.1 -feed.width/2 0];
%stop  = [feed.pos+.1 +feed.width/2 substrate.thickness];
%[CSX] = AddLumpedPort(CSX, 5 ,1 ,feed.R, start, stop, [0 0 1], true);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LuboJ antenna definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mesh.x = [-SimBox(1)/2 SimBox(1)/2 -substrate.width/2 substrate.width/2 feed.posY];
%% add patch mesh with 2/3 - 1/3 rule
mesh.x = [mesh.x -patch.width/2-max_res/2*0.66 -patch.width/2+max_res/2*0.33 patch.width/2+max_res/2*0.66 patch.width/2-max_res/2*0.33];
mesh.x = SmoothMeshLines( mesh.x, max_res, 1.4); % create a smooth mesh between specified mesh lines
mesh.y = [-SimBox(2)/2 SimBox(2)/2 -substrate.length/2 substrate.length/2 -feed.width/2 feed.width/2];
%% add patch mesh with 2/3 - 1/3 rule
mesh.y = [mesh.y -patch.length/2-max_res/2*0.66 -patch.length/2+max_res/2*0.33 patch.length/2+max_res/2*0.66 patch.length/2-max_res/2*0.33];
mesh.y = SmoothMeshLines( mesh.y, max_res, 1.4 );
mesh.z = [-SimBox(3)/2 linspace(0,-substrate.thickness,substrate.cells) SimBox(3) ];
mesh.z = SmoothMeshLines( mesh.z, max_res, 1.4 );
mesh = AddPML( mesh, [8 8 8 8 8 8] ); % add equidistant cells (air around the structure)

%add grid lines for thin routes LuboJ.
dGrid = 0.007;
mesh.x = [mesh.x linspace(-5.58628-dGrid, -5.51736+dGrid, 3)];
mesh.x = [mesh.x linspace(4.6869-dGrid, 4.75649+dGrid, 3)];
mesh.y = [mesh.y linspace(-14.2396-dGrid, -14.1783+dGrid, 3)];
mesh.z = [mesh.z 17e-6 -1.5-17e-6];
mesh.x = [mesh.x feed.posX-feed.width/2 feed.posX+feed.width/2];  %feedport grid
mesh.y = [mesh.y feed.posY-.1 feed.posY+.1];                      %feedport grid

%create GRID
CSX = DefineRectGrid( CSX, unit, mesh );

%import antenna geometry
CSX = AddMetal( CSX, 'patch' );
CSX = ImportSTL(CSX, 'patch',10, 'C:/Users/H364387/Documents/OpenEMS-Antenna-Simulations/Patch Antenna Circular Polarization 2/model/antenna.stl','Transform',{'Scale', 1});
CSX = AddMaterial( CSX, 'substrate' );
CSX = SetMaterialProperty( CSX, 'substrate', 'Epsilon', substrate.epsR, 'Kappa', substrate.kappa );
CSX = ImportSTL(CSX, 'substrate',10, 'C:/Users/H364387/Documents/OpenEMS-Antenna-Simulations/Patch Antenna Circular Polarization 2/model/substrate.stl','Transform',{'Scale', 1});
CSX = AddMetal( CSX, 'gnd' );
CSX = ImportSTL(CSX, 'gnd',10, 'C:/Users/H364387/Documents/OpenEMS-Antenna-Simulations/Patch Antenna Circular Polarization 2/model/gnd.stl','Transform',{'Scale', 1});


%% apply the excitation & resist as a current source
start = [feed.posX-feed.width/2 feed.posY-.1 0+35e-6];
stop  = [feed.posX+feed.width/2 feed.posY+.1 -substrate.thickness-35e-6];
[CSX] = AddLumpedPort(CSX, 5 ,1 ,feed.R, start, stop, [0 0 1], true);






%% dump magnetic field over the patch antenna
CSX = AddDump( CSX, 'Ht_', 'DumpType', 1, 'DumpMode', 2); % cell interpolated
start = [-patch.width -patch.length substrate.thickness+1];
stop  = [ patch.width  patch.length substrate.thickness+1];
CSX = AddBox( CSX, 'Ht_', 0, start, stop );



%%nf2ff calc
%[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', -SimBox/2, SimBox/2);

    %% write openEMS compatible xml-file
    WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

    %% show the structure
    CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

if (postprocessing_only==0)
    %% run openEMS
    RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts );
end
