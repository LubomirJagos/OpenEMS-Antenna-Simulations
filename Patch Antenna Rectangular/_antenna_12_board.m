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
mesh.y=[47.2283 45.5617 43.2283 40.2283 0.0000 2.8735 5.7469 8.6204 11.4938 14.3673 17.2407 20.1142 22.9876 25.8611 28.7345 31.6080 34.4814 37.3549 48.2283 49.2283 49.2283 50.1420 51.0557 51.9694 52.8831 53.7968 54.7106 55.6243 56.5380 57.4517 58.4517 58.4517 61.1452 63.8387 66.5323 69.2258 71.9194 74.6129 77.3065 80.0000];
mesh.x=[0.0000 2.7481 5.4963 8.2444 10.9926 13.7407 16.4889 19.2370 21.9852 24.7333 25.7333 25.7333 26.7271 27.7209 28.7147 29.7084 30.7022 31.6960 32.6898 33.6835 34.6773 35.6711 36.6649 37.6587 38.6524 39.6462 40.6400 41.6338 42.6275 43.6213 44.6151 45.6089 46.6026 47.5964 48.5902 49.5840 50.5778 51.5715 52.5653 53.5591 54.5529 55.5467 56.5467 56.5467 59.4783 62.4100 65.3417 68.2733 71.2050 74.1367 77.0683 80.0000];
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
layer_types(2).thickness = 1.6;
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
layer_types(4).thickness = 1.6;
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
layer_types(6).thickness = 1.6;
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
outline_xy(1, 2) = 80.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 80.0000; outline_xy(2, 3) = -80.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -80.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 4, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 6, outline_xy, 1);

%%% Copper objects
points0(1, 1) = 41.2750; points0(2, 1) = -51.4350;
points0(1, 2) = 41.2750; points0(2, 2) = -51.4350;
CSX = AddPcbrndTrace(CSX, PCBRND, 5, points0, 1.0000, 0);
points1(1, 1) = 41.2750; points1(2, 1) = -51.4350;
points1(1, 2) = 41.2750; points1(2, 2) = -51.4350;
CSX = AddPcbrndTrace(CSX, PCBRND, 3, points1, 1.0000, 0);
poly2_xy(1, 1) = 61.5950; poly2_xy(2, 1) = -23.4950;
poly2_xy(1, 2) = 61.5950; poly2_xy(2, 2) = -62.8650;
poly2_xy(1, 3) = 19.0500; poly2_xy(2, 3) = -62.8650;
poly2_xy(1, 4) = 19.0500; poly2_xy(2, 4) = -23.4950;
CSX = AddPcbrndPoly(CSX, PCBRND, 7, poly2_xy, 1);
points3(1, 1) = 41.2750; points3(2, 1) = -51.4350;
points3(1, 2) = 41.2750; points3(2, 2) = -51.4350;
CSX = AddPcbrndTrace(CSX, PCBRND, 7, points3, 1.0000, 0);
poly4_xy(1, 1) = 55.8800; poly4_xy(2, 1) = -48.8950;
poly4_xy(1, 2) = 55.8800; poly4_xy(2, 2) = -57.7850;
poly4_xy(1, 3) = 25.4000; poly4_xy(2, 3) = -57.7850;
poly4_xy(1, 4) = 25.4000; poly4_xy(2, 4) = -48.8950;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly4_xy, 1);
points5(1, 1) = 41.2750; points5(2, 1) = -51.4350;
points5(1, 2) = 41.2750; points5(2, 2) = -51.4350;
CSX = AddPcbrndTrace(CSX, PCBRND, 1, points5, 1.0000, 0);
%%% Port(s) on terminals
