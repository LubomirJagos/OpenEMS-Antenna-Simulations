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

currDir = strrep(pwd(), '\', '\\');

%LuboJ, JUST TO SEE RESULT
%openEMS_opts = '--no-simulation';
%openEMS_opts = '--debug-PEC --no-simulation';
openEMS_opts = '';

%% setup the simulation
physical_constants;
unit = 1e-3; % all length in mm

microstrip50OhmWidth = 3.32;

% width in x-direction
% length in y-direction
% main radiation in z-direction
patch.width  = abs(-22.159637) + abs(22.561216); % resonant length
patch.length = abs(-20.170856) + abs(20.919703);

substrate.epsR   = 3.6;
substrate.kappa  = 1e-3 * 2*pi*1.6e9 * EPS0*substrate.epsR;
substrate.start.x  = -22.159637;
substrate.start.y  = -20.170856;
substrate.end.x  = 22.561216;
substrate.end.y  = 20.919703;
substrate.length = 80;
substrate.thickness = 1.5;
substrate.cells = 4;

outputPort.A.start = [-20.837893 -17.95599 0.035];
outputPort.A.end = [-20.837893+0.2 -14.636 -1.535];
outputPort.B.start = [20.837893 -17.95599 0.035];
outputPort.B.end = [20.837893-0.2 -14.636 -1.535];

feed.posX = -1.66;
feed.posY = 19.558384;
feed.width = microstrip50OhmWidth;
feed.R = 50; % feed resistance

resistor.start = [-0.837893 -7.956 0];
resistor.end = [0.837893 -8.874228 0.035];

% size of the simulation box
SimBox = [60 60 25];

%% prepare simulation folder
Sim_Path = 'tmp';
Sim_CSX = 'wiklinson.xml';
[status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
[status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder

%% setup FDTD parameter & excitation function
max_timesteps = 8e6;
min_decrement = 1e-5; % equivalent to -50 dB
f0 = 1.6e9; % center frequency
fc = 800e6; % 20 dB corner frequency
FDTD = InitFDTD( 'NrTS', max_timesteps, 'EndCriteria', min_decrement );

FDTD = SetGaussExcite( FDTD, f0, fc );
%FDTD = SetSinusExcite(FDTD,f0); %LuboJ try sinus excitation

BC = {'MUR' 'MUR' 'MUR' 'MUR' 'MUR' 'MUR'}; % boundary conditions
if (use_pml>0)
    BC = {'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8' 'PML_8'}; % use pml instead of mur
end
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh
% currently, openEMS cannot automatically generate a mesh
max_res = c0 / (f0+fc) / unit / 20; % cell size: lambda/20

CSX = InitCSX();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MESH X
mesh.x = [(-SimBox(1)/2 : 3 : substrate.start.x) (substrate.end.x : 3 : SimBox(1)/2) (substrate.start.x : 0.3 : substrate.end.x)];

% MESH Y
mesh.y = [(-SimBox(2)/2 : 3 : substrate.start.y) (substrate.end.y : 3 : SimBox(2)/2) (substrate.start.y : 0.3 : substrate.end.y)];

% MESH Z
mesh.z = [linspace(0.016,-substrate.thickness-0.016,substrate.cells)];

mesh = AddPML( mesh, [8 8 8 8 8 8] ); % add equidistant cells (air around the structure)

%add grid lines for thin routes LuboJ.
dGrid = 0.007;

% GRID
CSX = DefineRectGrid( CSX, unit, mesh );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEOMETRY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GEOMETRY
CSX = AddMetal( CSX, 'wilkinson' );
CSX = ImportSTL(CSX, 'wilkinson',10, [currDir '\\model\\wilkinson.stl'],'Transform',{'Scale', 1});
CSX = AddMaterial( CSX, 'substrate' );
CSX = SetMaterialProperty( CSX, 'substrate', 'Epsilon', substrate.epsR, 'Kappa', substrate.kappa );
CSX = ImportSTL(CSX, 'substrate',10, [currDir '\\model\\substrate.stl'],'Transform',{'Scale', 1});
CSX = AddMetal( CSX, 'gnd' );
CSX = ImportSTL(CSX, 'gnd',10, [currDir '\\model\\gnd.stl'],'Transform',{'Scale', 1});

%% EXCITATION, PORT 1
%[CSX] = AddExcitation(CSX, 'Excitation', 0, [0 0 1]);
start = [feed.posX feed.posY-0.1 0+35e-6];
stop  = [feed.posX+feed.width feed.posY-0.2 -substrate.thickness-35e-6];
[CSX port{1}] = AddLumpedPort(CSX, 5 ,1 ,feed.R, start, stop, [0 0 1], true);
%% OUTPUT PORT 2
start = outputPort.A.start;
stop  = outputPort.A.end;
[CSX port{2}] = AddLumpedPort(CSX, 5 ,2 ,feed.R, start, stop, [0 0 1]);
%% OUTPUT PORT 3
start = outputPort.B.start;
stop  = outputPort.B.end;
[CSX port{3}] = AddLumpedPort(CSX, 5 ,3 ,feed.R, start, stop, [0 0 1]);

%% RESISTOR
%first add element to list that it's there in model
[CSX] = AddLumpedElement(CSX, 'Resistor', 2, 'Caps', 1, 'R', 100);
%volume coordinates
##start = [-0.937893 -7.956 0];
##stop = [0.937893 -8.874228 2];  %due resistor is in Z direction it must contains at least 2 grid lines in that direction os it's set higher than minimal grid Y 
start = [-0.837893 -7.956 0];
stop = [0.837893 -8.874228 2];  %due resistor is in Z direction it must contains at least 2 grid lines in that direction os it's set higher than minimal grid Y 
%second add space volume which is assigned to that element defined previously
[CSX] = AddBox(CSX, 'Resistor', 0, start, stop);

%% H-FIELD MONITOR
CSX = AddDump( CSX, 'Ht_', 'DumpType', 1, 'DumpMode', 2); % cell interpolated
start = [substrate.start.x substrate.start.y 1];
stop  = [substrate.end.x  substrate.end.y 1];
CSX = AddBox( CSX, 'Ht_', 0, start, stop );

%% E-FIELD MONITOR
CSX = AddDump( CSX, 'Et_', 'DumpType', 0, 'DumpMode', 2); % cell interpolated
start = [substrate.start.x substrate.start.y 1];
stop  = [substrate.end.x  substrate.end.y 1];
CSX = AddBox( CSX, 'Et_', 0, start, stop );


%%NF2FF CALCULATION
%[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', -SimBox/2, SimBox/2);

    %% write openEMS compatible xml-file
    WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

    %% show the structure
    CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

if (postprocessing_only==0)
    %% run openEMS
    RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts );
end
