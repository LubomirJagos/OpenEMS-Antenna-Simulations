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
mesh.y=[27.9433 26.1933 23.6933 0.0000 2.3693 4.7387 7.1080 9.4773 11.8467 14.2160 16.5853 18.9547 21.3240 28.9433 29.9433 29.9433 30.9225 31.9017 32.8808 33.8600 34.8392 35.8183 36.7975 37.7767 38.7558 39.7350 40.7142 41.6933 42.6725 43.6517 44.6308 45.6100 46.5892 47.5683 48.5475 49.5267 50.5058 51.4850 52.4642 53.4433 54.4225 55.4016 56.3808 57.3600 58.3391 59.3183 60.2975 61.2767 61.5950 62.2767 62.2767 63.2767 65.0267 67.5267 70.0237 72.5207 75.0178 77.5148 80.0119 82.5089 85.0059 87.5030 90.0000];
mesh.x=[26.5733 24.8233 22.3233 0.0000 2.4804 4.9607 7.4411 9.9215 12.4019 14.8822 17.3626 19.8430 27.5733 28.5733 28.5733 29.5259 30.4785 31.4311 32.3837 33.3363 34.2889 35.2415 36.1941 37.1467 38.0993 39.0518 40.0044 40.9570 41.9096 42.8622 43.8148 44.7674 45.7200 45.7200 46.6748 47.6296 48.5844 49.5393 50.4941 51.4489 52.4037 53.3585 54.3133 55.2681 56.2230 57.1778 58.1326 59.0874 60.0422 60.9970 61.9518 62.9067 63.9067 63.9067 64.9067 66.6567 69.1567 71.4726 73.7885 76.1044 78.4204 80.7363 83.0522 85.3681 87.6841 90.0000];
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
outline_xy(1, 2) = 90.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 90.0000; outline_xy(2, 3) = -90.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -90.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 3, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 79.3750; poly0_xy(2, 1) = -14.6050;
poly0_xy(1, 2) = 79.3750; poly0_xy(2, 2) = -77.4700;
poly0_xy(1, 3) = 13.9700; poly0_xy(2, 3) = -77.4700;
poly0_xy(1, 4) = 13.9700; poly0_xy(2, 4) = -14.6050;
CSX = AddPcbrndPoly(CSX, PCBRND, 4, poly0_xy, 1);
poly1_xy(1, 1) = 28.2400; poly1_xy(2, 1) = -29.6100;
poly1_xy(1, 2) = 63.2400; poly1_xy(2, 2) = -29.6100;
poly1_xy(1, 3) = 63.2400; poly1_xy(2, 3) = -61.6100;
poly1_xy(1, 4) = 28.2400; poly1_xy(2, 4) = -61.6100;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 45.4700; poly2_xy(2, 1) = -61.3450;
poly2_xy(1, 2) = 45.4700; poly2_xy(2, 2) = -61.8450;
poly2_xy(1, 3) = 45.9700; poly2_xy(2, 3) = -61.8450;
poly2_xy(1, 4) = 45.9700; poly2_xy(2, 4) = -61.3450;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 45.7200; point1(2, 1) = -61.5950;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 4);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);
