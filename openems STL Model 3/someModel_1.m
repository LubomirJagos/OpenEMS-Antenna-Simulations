%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIBRARIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('C:\Users\H364387\Downloads\pcb2csx\matlab');
addpath('C:\Users\H364387\Downloads\openems\matlab');   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% offset on the whole layout to locate it relative to the simulation origin
offset.x = 0.0000;
offset.y = 0.0000;
offset.z = 0;

%grid
z_bottom_copper=3.0000
mesh.y=[27.9433 26.1933 23.6933 0.0000 2.3693 4.7387 7.1080 9.4773 11.8467 14.2160 16.5853 18.9547 21.3240 28.9433 29.9433 29.9433 30.9225 31.9017 32.8808 33.8600 34.8392 35.8183 36.7975 37.7767 38.7558 39.7350 40.7142 41.6933 42.6725 43.6517 44.6308 45.6100 46.5892 47.5683 48.5475 49.5267 50.5058 51.4850 52.4642 53.4433 54.4225 55.4016 56.3808 57.3600 58.3391 59.3183 60.2975 61.2767 61.5950 62.2767 62.2767 63.2767 65.0267 67.5267 70.0237 72.5207 75.0178 77.5148 80.0119 82.5089 85.0059 87.5030 90.0000];
mesh.x=[26.5733 24.8233 22.3233 0.0000 2.4804 4.9607 7.4411 9.9215 12.4019 14.8822 17.3626 19.8430 27.5733 28.5733 28.5733 29.5259 30.4785 31.4311 32.3837 33.3363 34.2889 35.2415 36.1941 37.1467 38.0993 39.0518 40.0044 40.9570 41.9096 42.8622 43.8148 44.7674 45.7200 45.7200 46.6748 47.6296 48.5844 49.5393 50.4941 51.4489 52.4037 53.3585 54.3133 55.2681 56.2230 57.1778 58.1326 59.0874 60.0422 60.9970 61.9518 62.9067 63.9067 63.9067 64.9067 66.6567 69.1567 71.4726 73.7885 76.1044 78.4204 80.7363 83.0522 85.3681 87.6841 90.0000];
mesh.z=[0.0000 0.2500 0.5000 0.7500 1.0000 1.2500 1.5000 1.7500 2.0000 2.2500 2.5000 2.7500 3.0000 -4.0000 -3.3333 -2.6667 -2.0000 -1.3333 -0.6667 3.0000 3.6667 4.3333 5.0000 5.6667 6.3333];
mesh.x = mesh.x .+ offset.x;
mesh.y = offset.y .- mesh.y;
mesh.z = z_bottom_copper .- mesh.z .+ offset.z;
CSX = DefineRectGrid(CSX, unit, mesh);

%define dielectric layer
CSX = AddMaterial(CSX,'MyMetal');
kappa = 0.01;
CSX = SetMaterialProperty( CSX, 'MyMetal', 'Epsilon', 4.1, 'Mue', 1, 'kappa',kappa );

%MUST BE FULL PATH HERE!
CSX = ImportSTL(CSX, 'MyMetal',10, 'C:/Users/H364387/Documents/KiCad/openems STL Model 3/macho.stl','Transform',{'Scale', 1});
CSX = ImportSTL(CSX, 'MyMetal',10, 'C:/Users/H364387/Documents/KiCad/openems STL Model 3/model_1.stl','Transform',{'Scale', 1});

% define feedline 1 (oriented in z-direction 10mm long
%CSX = AddConductingSheet(CSX, 'Copper', cond, thickness);
%CSX = ImportSTL(CSX, 'Copper',10, 'mlin_cpld_top.stl','Transform',{'Scale', 1});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE OUTPUT FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sim_Path = '.';
Sim_CSX = 'csxcad.xml';
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );
CSXGeomPlot( [Sim_Path '/' Sim_CSX] );


