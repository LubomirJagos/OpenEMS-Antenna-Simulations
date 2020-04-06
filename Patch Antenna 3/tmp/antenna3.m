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
mesh.y=[0.0000 2.2185 4.4371 6.6556 8.8742 11.0927 13.3112 15.5298 17.7483 18.7483 18.7483 19.7471 20.7458 21.7446 22.7434 23.7421 24.7409 25.7396 26.7384 27.7372 28.7359 29.7347 30.7334 31.7322 32.7309 33.7297 34.7285 35.7272 36.7260 37.7247 38.7235 39.7223 40.7210 41.7198 42.7185 43.7173 44.7160 45.7148 46.7136 47.7123 48.7111 49.7098 50.7086 51.7073 52.7061 53.7049 54.7036 55.7024 56.7011 57.6999 58.6987 59.6974 60.6962 61.6949 62.6937 63.6924 64.6912 65.6900 65.6900 66.6622 67.6343 68.6065 69.5786 70.5508 71.5229 72.4951 73.4672 74.4394 75.4116 76.3837 77.3559 78.3280 79.3002 80.2723 81.2445 82.2167 83.2167 83.2167 85.6143 88.0119 90.4095 92.8071 95.2048 97.6024 100.0000];
mesh.x=[0.0000 2.4448 4.8895 7.3343 9.7790 12.2238 14.6686 17.1133 18.1133 18.1133 19.0999 20.0866 21.0732 22.0598 23.0464 24.0330 25.0196 26.0062 26.9929 27.9795 28.9661 29.9527 30.9393 31.9259 32.9125 33.8992 34.8858 35.8724 36.8590 37.8456 38.8322 39.8188 40.8055 41.7921 42.7787 43.7653 44.7519 45.7385 46.7251 47.7118 48.6984 49.6850 49.6850 50.6619 51.6389 52.6158 53.5927 54.5696 55.5466 56.5235 57.5004 58.4773 59.4543 60.4312 61.4081 62.3851 63.3620 64.3389 65.3158 66.2928 67.2697 68.2466 69.2235 70.2005 71.1774 72.1543 73.1312 74.1082 75.0851 76.0620 77.0390 78.0159 78.9928 79.9697 80.9467 81.9467 81.9467 84.2033 86.4600 88.7167 90.9733 93.2300 95.4867 97.7433 100.0000];
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
layers(3).name = 'grp_12';
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
outline_xy(1, 2) = 100.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 100.0000; outline_xy(2, 3) = -100.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -100.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 3, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 81.2800; poly0_xy(2, 1) = -18.4150;
poly0_xy(1, 2) = 81.2800; poly0_xy(2, 2) = -82.5500;
poly0_xy(1, 3) = 17.7800; poly0_xy(2, 3) = -82.5500;
poly0_xy(1, 4) = 17.7800; poly0_xy(2, 4) = -18.4150;
CSX = AddPcbrndPoly(CSX, PCBRND, 4, poly0_xy, 1);
poly1_xy(1, 1) = 65.7850; poly1_xy(2, 1) = -33.3900;
poly1_xy(1, 2) = 65.7850; poly1_xy(2, 2) = -65.6900;
poly1_xy(1, 3) = 33.4850; poly1_xy(2, 3) = -65.6900;
poly1_xy(1, 4) = 33.4850; poly1_xy(2, 4) = -33.3900;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 49.4350; poly2_xy(2, 1) = -65.4400;
poly2_xy(1, 2) = 49.4350; poly2_xy(2, 2) = -65.9400;
poly2_xy(1, 3) = 49.9350; poly2_xy(2, 3) = -65.9400;
poly2_xy(1, 4) = 49.9350; poly2_xy(2, 4) = -65.4400;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 49.6850; point1(2, 1) = -65.6900;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 4);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);
