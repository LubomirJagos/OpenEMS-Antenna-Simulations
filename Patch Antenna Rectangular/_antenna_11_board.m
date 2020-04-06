%%% User tunables

%% base_priority and offset: chassis for the board to sit in.
% base priority: if the board displaces the model of the chassis or the other way around.
base_priority=0;

% offset on the whole layout to locate it relative to the simulation origin
offset.x = 0.0000;
offset.y = 0.0000;
offset.z = 0;

% void is the material used for: fill holes, cutouts in substrate, etc
void.name = 'AIR';
void.epsilon = 1.000000;
void.mue = 1.000000;
% void.kappa = kappa;
% void.sigma = sigma;

% how many points should be used to describe the round end of traces.
kludge.segments = 10;


%%% Board mesh, part 2
z_bottom_copper=4.8000
mesh.y=[166.9150 156.0900 140.5900 0.0000 14.0590 28.1180 42.1770 56.2360 70.2950 84.3540 98.4130 112.4720 126.5310 173.0650 179.2150 182.8800 193.3850 195.4350 199.5350 201.5850 201.5850 215.6443 229.7036 243.7629 257.8221 271.8814 285.9407 300.0000];
mesh.x=[0.0000 15.3800 30.7600 46.1400 61.5200 76.9000 92.2800 107.6600 113.8100 113.8100 119.5950 125.3800 131.1650 136.9500 142.7350 148.5200 154.3050 154.3050 160.2714 166.2379 172.2043 178.1707 184.1371 190.1036 196.0700 202.2200 202.2200 216.1886 230.1571 244.1257 258.0943 272.0629 286.0314 300.0000];
mesh.z=[0.0000 0.2667 0.5333 0.8000 1.0667 1.3333 1.6000 1.8667 2.1333 2.4000 2.6667 2.9333 3.2000 3.4667 3.7333 4.0000 4.2667 4.5333 4.8000 -4.0000 -3.3333 -2.6667 -2.0000 -1.3333 -0.6667 4.8000 5.4667 6.1333 6.8000 7.4667 8.1333];
mesh.x = mesh.x .+ offset.x;
mesh.y = offset.y .- mesh.y;
mesh.z = z_bottom_copper .- mesh.z .+ offset.z;
mesh = AddPML(mesh, 8);
CSX = DefineRectGrid(CSX, unit, mesh);

%%% Layer mapping
layers(1).number = 1;
layers(1).name = 'top_copper';
layers(1).clearn = 0;
layer_types(1).name = 'COPPER_1';
layer_types(1).subtype = 2;
layer_types(1).thickness = 0.0/1000;
layer_types(1).conductivity = 56*10^6;

layers(2).number = 2;
layers(2).name = 'grp_4';
layers(2).clearn = 0;
layer_types(2).name = 'SUBSTRATE_2';
layer_types(2).subtype = 3;
layer_types(2).thickness = 1.524;
layer_types(2).epsilon = 3.38;
layer_types(2).mue = 0;
layer_types(2).kappa = 0;
layer_types(2).sigma = 0;

layers(3).number = 3;
layers(3).name = 'Intern';
layers(3).clearn = 0;
layer_types(3).name = 'COPPER_3';
layer_types(3).subtype = 2;
layer_types(3).thickness = 0.0/1000;
layer_types(3).conductivity = 56*10^6;

layers(4).number = 4;
layers(4).name = 'grp_6';
layers(4).clearn = 0;
layer_types(4).name = 'SUBSTRATE_4';
layer_types(4).subtype = 3;
layer_types(4).thickness = 1.524;
layer_types(4).epsilon = 3.38;
layer_types(4).mue = 0;
layer_types(4).kappa = 0;
layer_types(4).sigma = 0;

layers(5).number = 5;
layers(5).name = 'Intern';
layers(5).clearn = 0;
layer_types(5).name = 'COPPER_5';
layer_types(5).subtype = 2;
layer_types(5).thickness = 0.0/1000;
layer_types(5).conductivity = 56*10^6;

layers(6).number = 6;
layers(6).name = 'grp_8';
layers(6).clearn = 0;
layer_types(6).name = 'SUBSTRATE_6';
layer_types(6).subtype = 3;
layer_types(6).thickness = 1.524;
layer_types(6).epsilon = 3.38;
layer_types(6).mue = 0;
layer_types(6).kappa = 0;
layer_types(6).sigma = 0;

layers(7).number = 7;
layers(7).name = 'bottom_copper';
layers(7).clearn = 0;
layer_types(7).name = 'COPPER_7';
layer_types(7).subtype = 2;
layer_types(7).thickness = 0.0/1000;
layer_types(7).conductivity = 56*10^6;


%%% Initialize pcb2csx
PCBRND = InitPCBRND(layers, layer_types, void, base_priority, offset, kludge);
CSX = InitPcbrndLayers(CSX, PCBRND);

%%% Board outline
outline_xy(1, 1) = 0; outline_xy(2, 1) = 0;
outline_xy(1, 2) = 300.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 300.0000; outline_xy(2, 3) = -300.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -300.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 4, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 6, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 252.7300; poly0_xy(2, 1) = -46.3550;
poly0_xy(1, 2) = 252.7300; poly0_xy(2, 2) = -246.3800;
poly0_xy(1, 3) = 52.7050; poly0_xy(2, 3) = -246.3800;
poly0_xy(1, 4) = 52.7050; poly0_xy(2, 4) = -46.3550;
CSX = AddPcbrndPoly(CSX, PCBRND, 7, poly0_xy, 1);
poly1_xy(1, 1) = 111.7600; poly1_xy(2, 1) = -197.4850;
poly1_xy(1, 2) = 111.7600; poly1_xy(2, 2) = -177.1650;
poly1_xy(1, 3) = 198.1200; poly1_xy(2, 3) = -177.1650;
poly1_xy(1, 4) = 198.1200; poly1_xy(2, 4) = -197.4850;
poly1_xy(1, 5) = 110.4900; poly1_xy(2, 5) = -197.4850;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
points2(1, 1) = 154.3050; points2(2, 1) = -182.8800;
points2(1, 2) = 154.3050; points2(2, 2) = -182.8800;
CSX = AddPcbrndTrace(CSX, PCBRND, 1, points2, 2.0000, 0);
%%% Port(s) on terminals

point1(1, 1) = 154.3050; point1(2, 1) = -182.8800;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 3);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);
