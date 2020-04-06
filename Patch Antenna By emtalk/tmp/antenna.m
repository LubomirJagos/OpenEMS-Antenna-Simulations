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
z_bottom_copper=3.0000
mesh.y=[0.0000 1.8202 3.6404 5.4605 7.2807 7.9807 7.9807 8.6744 9.3680 10.0616 10.7552 11.4489 12.1425 12.8361 13.5298 14.2234 14.9170 15.6107 16.3043 16.9979 17.6915 18.3852 19.0788 19.7724 20.4661 21.1597 21.8533 22.5470 23.2406 23.9342 24.6278 25.3215 26.0151 26.7087 27.4024 28.0960 28.7896 29.4833 30.1769 30.8705 31.5641 32.2578 32.9514 33.6450 34.3387 35.0323 35.7259 36.4196 37.1132 37.8068 38.5004 39.1941 39.8877 40.5813 41.2750 41.2750 41.9507 42.6264 43.3021 43.9778 44.6535 45.3292 46.0049 46.6806 47.3563 48.0320 48.7077 49.3834 50.0591 50.7591 50.7591 52.6072 54.4554 56.3036 58.1518 60.0000];
mesh.x=[0.0000 2.1660 4.3319 6.4979 8.6638 10.8298 12.9957 13.6957 13.6957 14.3925 15.0893 15.7860 16.4828 17.1796 17.8763 18.5731 19.2699 19.9667 20.6634 21.3602 22.0570 22.7537 23.4505 24.1473 24.8440 25.5408 26.2376 26.9344 27.6311 28.3279 29.0247 29.7214 30.4182 31.1150 31.1150 31.7966 32.4781 33.1597 33.8412 34.5228 35.2044 35.8859 36.5675 37.2491 37.9306 38.6122 39.2937 39.9753 40.6569 41.3384 42.0200 42.7016 43.3831 44.0647 44.7462 45.4278 46.1094 46.7909 47.4725 48.1541 48.8541 48.8541 51.0832 53.3124 55.5416 57.7708 60.0000];
mesh.z=[0.0000 0.2500 0.5000 0.7500 1.0000 1.2500 1.5000 1.7500 2.0000 2.2500 2.5000 2.7500 3.0000 -4.0000 -3.3333 -2.6667 -2.0000 -1.3333 -0.6667 3.0000 3.6667 4.3333 5.0000 5.6667 6.3333];
mesh.x = mesh.x .+ offset.x;
mesh.y = offset.y .- mesh.y;
mesh.z = z_bottom_copper .- mesh.z .+ offset.z;
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
layer_types(2).thickness = 1.5;
layer_types(2).epsilon = 3.66;
layer_types(2).mue = 0;
layer_types(2).kappa = 0;
layer_types(2).sigma = 0;

layers(3).number = 3;
layers(3).name = 'grp_6';
layers(3).clearn = 0;
layer_types(3).name = 'SUBSTRATE_3';
layer_types(3).subtype = 3;
layer_types(3).thickness = 1.5;
layer_types(3).epsilon = 3.66;
layer_types(3).mue = 0;
layer_types(3).kappa = 0;
layer_types(3).sigma = 0;

layers(4).number = 4;
layers(4).name = 'bottom_copper';
layers(4).clearn = 0;
layer_types(4).name = 'COPPER_4';
layer_types(4).subtype = 2;
layer_types(4).thickness = 0.0/1000;
layer_types(4).conductivity = 56*10^6;


%%% Initialize pcb2csx
PCBRND = InitPCBRND(layers, layer_types, void, base_priority, offset, kludge);
CSX = InitPcbrndLayers(CSX, PCBRND);

%%% Board outline
outline_xy(1, 1) = 0; outline_xy(2, 1) = 0;
outline_xy(1, 2) = 60.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 60.0000; outline_xy(2, 3) = -60.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -60.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 3, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 48.3874; poly0_xy(2, 1) = -7.7474;
poly0_xy(1, 2) = 48.3874; poly0_xy(2, 2) = -50.2924;
poly0_xy(1, 3) = 13.4624; poly0_xy(2, 3) = -50.2924;
poly0_xy(1, 4) = 13.4624; poly0_xy(2, 4) = -7.7474;
CSX = AddPcbrndPoly(CSX, PCBRND, 4, poly0_xy, 1);
poly1_xy(1, 1) = 20.9724; poly1_xy(2, 1) = -15.5424;
poly1_xy(1, 2) = 41.2724; poly1_xy(2, 2) = -15.5424;
poly1_xy(1, 3) = 41.2724; poly1_xy(2, 3) = -41.7424;
poly1_xy(1, 4) = 20.9724; poly1_xy(2, 4) = -41.7424;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 30.6150; poly2_xy(2, 1) = -40.7750;
poly2_xy(1, 2) = 30.6150; poly2_xy(2, 2) = -41.7750;
poly2_xy(1, 3) = 31.6150; poly2_xy(2, 3) = -41.7750;
poly2_xy(1, 4) = 31.6150; poly2_xy(2, 4) = -40.7750;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 31.1150; point1(2, 1) = -41.2750;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 4);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 216.000000, start1, stop1, [0 0 -1], true);
