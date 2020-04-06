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
mesh.y=[98.4017 94.4017 88.7017 0.0000 5.5439 11.0877 16.6316 22.1754 27.7193 33.2631 38.8070 44.3508 49.8947 55.4385 60.9824 66.5262 72.0701 77.6140 83.1578 100.7017 103.0017 103.0017 105.2633 107.5248 109.7864 112.0480 114.3096 116.5712 118.8328 121.0944 123.3559 125.6175 127.8791 130.1407 132.4023 134.6639 136.9255 139.1871 141.4486 143.7102 145.9718 148.2334 150.4950 152.7566 155.0182 157.2798 159.5413 161.8029 164.0645 166.3261 168.5877 170.8493 173.1109 175.3724 177.6340 179.8956 182.1572 184.4188 186.6804 188.9420 191.2036 193.4651 195.7267 197.9883 200.2883 200.2883 202.5883 206.5883 212.2883 217.7703 223.2523 228.7343 234.2162 239.6982 245.1802 250.6622 256.1442 261.6261 267.1081 272.5901 278.0721 283.5541 289.0360 294.5180 300.0000];
mesh.x=[104.1167 100.1167 94.4167 0.0000 5.5539 11.1078 16.6618 22.2157 27.7696 33.3235 38.8774 44.4314 49.9853 55.5392 61.0931 66.6471 72.2010 77.7549 83.3088 88.8627 106.4167 108.7167 108.7167 110.9643 113.2120 115.4597 117.7073 119.9550 122.2027 124.4503 126.6980 128.9457 131.1933 133.4410 135.6887 137.9363 140.1840 142.4317 144.6793 146.9270 149.1747 151.4223 153.6700 155.9177 158.1653 160.4130 162.6607 164.9083 167.1560 169.4036 171.6513 173.8990 176.1466 178.3943 180.6420 182.8896 185.1373 187.3850 189.6326 191.8803 194.1280 196.3756 198.6233 200.9233 200.9233 203.2233 207.2233 212.9233 218.3656 223.8079 229.2502 234.6925 240.1348 245.5771 251.0194 256.4617 261.9040 267.3462 272.7885 278.2308 283.6731 289.1154 294.5577 300.0000];
mesh.z=[0.0000 0.2667 0.5333 0.8000 1.0667 1.3333 1.6000 1.8667 2.1333 2.4000 2.6667 2.9333 3.2000 3.4667 3.7333 4.0000 4.2667 4.5333 4.8000 -4.0000 -3.3333 -2.6667 -2.0000 -1.3333 -0.6667 4.8000 5.4667 6.1333 6.8000 7.4667 8.1333];
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
layer_types(2).thickness = 1.6;
layer_types(2).epsilon = 3.66;
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
layer_types(4).epsilon = 3.66;
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
layer_types(6).epsilon = 3.66;
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
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly0_xy, 1);
poly1_xy(1, 1) = 199.3900; poly1_xy(2, 1) = -102.2350;
poly1_xy(1, 2) = 199.3900; poly1_xy(2, 2) = -198.7550;
poly1_xy(1, 3) = 107.9500; poly1_xy(2, 3) = -198.7550;
poly1_xy(1, 4) = 107.9500; poly1_xy(2, 4) = -102.2350;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
points2(1, 1) = 154.3050; points2(2, 1) = -182.8800;
points2(1, 2) = 154.3050; points2(2, 2) = -182.8800;
CSX = AddPcbrndTrace(CSX, PCBRND, 1, points2, 2.0000, 0);
%%% Port(s) on terminals

point1(1, 1) = 154.3050; point1(2, 1) = -182.8800;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 3);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);
