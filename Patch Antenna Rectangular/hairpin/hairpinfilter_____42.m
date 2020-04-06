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
mesh.y=[40.2483 38.4983 35.9983 0.0000 2.3999 4.7998 7.1997 9.5996 11.9994 14.3993 16.7992 19.1991 21.5990 23.9989 26.3988 28.7987 31.1985 33.5984 41.2483 42.2483 42.2483 43.2432 44.2380 45.2329 46.2277 47.2226 48.2174 49.2123 50.2071 51.2020 52.1968 53.1917 54.1865 55.1814 56.1762 57.1711 58.1659 59.1607 60.1556 61.1504 62.1453 63.1401 64.1350 64.1350 65.0875 66.0400 66.9925 67.9450 68.8975 69.8500 70.8025 71.7550 72.7075 73.6600 73.8817 74.8817 74.8817 75.8817 77.6317 80.1317 82.6234 85.1152 87.6070 90.0987 92.5905 95.0823 97.5741 100.0658 102.5576 105.0494 107.5411 110.0329 112.5247 115.0164 117.5082 120.0000];
mesh.x=[41.5983 39.8483 37.3483 0.0000 2.4899 4.9798 7.4697 9.9596 12.4494 14.9393 17.4292 19.9191 22.4090 24.8989 27.3888 29.8787 32.3685 34.8584 42.5983 43.5983 43.5983 44.5976 45.5969 46.5961 47.5954 48.5947 49.5939 50.5932 51.5925 52.5917 53.5910 54.5903 55.5895 56.5888 57.5881 58.5873 59.5866 60.5859 61.5851 62.5844 63.5837 64.5829 65.5822 66.5815 67.5807 68.5800 68.5800 69.5501 70.5201 71.4902 72.4603 73.4303 74.4004 75.3705 76.3405 77.3106 78.2807 79.2507 80.2208 81.1909 82.1609 83.1310 84.1011 85.0711 86.0412 87.0113 87.9813 88.9514 89.9215 90.8915 91.8616 92.8317 93.8317 93.8317 94.8317 96.5817 99.0817 101.4886 103.8956 106.3025 108.7095 111.1165 113.5234 115.9304 118.3373 120.7443 123.1513 125.5582 127.9652 130.3721 132.7791 135.1861 137.5930 140.0000];
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
outline_xy(1, 2) = 140.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 140.0000; outline_xy(2, 3) = -120.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -120.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 3, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 118.1650; poly0_xy(2, 1) = -16.9150;
poly0_xy(1, 2) = 118.1650; poly0_xy(2, 2) = -99.2150;
poly0_xy(1, 3) = 18.4150; poly0_xy(2, 3) = -99.2150;
poly0_xy(1, 4) = 18.4150; poly0_xy(2, 4) = -16.9150;
CSX = AddPcbrndPoly(CSX, PCBRND, 4, poly0_xy, 1);
poly1_xy(1, 1) = 43.2650; poly1_xy(2, 1) = -41.9150;
poly1_xy(1, 2) = 93.1650; poly1_xy(2, 2) = -41.9150;
poly1_xy(1, 3) = 93.1650; poly1_xy(2, 3) = -74.2150;
poly1_xy(1, 4) = 43.2650; poly1_xy(2, 4) = -74.2150;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 68.3300; poly2_xy(2, 1) = -73.4100;
poly2_xy(1, 2) = 68.3300; poly2_xy(2, 2) = -73.9100;
poly2_xy(1, 3) = 68.8300; poly2_xy(2, 3) = -73.9100;
poly2_xy(1, 4) = 68.8300; poly2_xy(2, 4) = -73.4100;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
poly3_xy(1, 1) = 68.3300; poly3_xy(2, 1) = -63.8850;
poly3_xy(1, 2) = 68.3300; poly3_xy(2, 2) = -64.3850;
poly3_xy(1, 3) = 68.8300; poly3_xy(2, 3) = -64.3850;
poly3_xy(1, 4) = 68.8300; poly3_xy(2, 4) = -63.8850;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly3_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 68.5800; point1(2, 1) = -73.6600;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 4);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);

point2(1, 1) = 68.5800; point2(2, 1) = -64.1350;
[start2, stop2] = CalcPcbrnd2PortV(PCBRND, point2, 1, 4);
[CSX, port{2}] = AddLumpedPort(CSX, 999, 2, 50.000000, start2, stop2, [0 0 -1]);
