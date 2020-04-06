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
mesh.y=[0.0000 1.8968 3.7937 5.6906 7.5874 9.4842 11.3811 13.2780 15.1748 17.0717 18.9685 20.8653 22.7622 24.6591 25.1591 25.1591 25.6575 26.1560 26.6545 27.1530 27.6515 28.1500 28.6484 29.1469 29.6454 30.1439 30.6424 31.1409 31.6394 32.1378 32.6363 33.1348 33.6333 34.1318 34.6303 35.1287 35.6272 36.1257 36.6242 37.1227 37.6212 38.1196 38.6181 39.1166 39.6151 40.1136 40.6121 41.1105 41.6090 42.1075 42.6060 43.1045 43.6030 44.1015 44.5999 45.0984 45.5969 46.0954 46.5939 47.0924 47.0924 47.5886 48.0848 48.5810 49.0772 49.5735 50.0697 50.5659 51.0621 51.5583 52.0545 52.5507 53.0469 53.5431 54.0394 54.5356 55.0318 55.5280 56.0242 56.5204 57.0166 57.5128 58.0091 58.5053 59.0015 59.4977 59.9939 60.4901 60.9863 61.4825 61.9788 62.4750 62.9712 63.4674 63.9636 64.4598 64.9560 65.4522 65.9484 66.4447 66.9409 67.4371 67.9333 68.4295 68.9257 69.4257 69.4257 71.3366 73.2475 75.1584 77.0693 78.9802 80.8911 82.8020 84.7129 86.6238 88.5346 90.4455 92.3564 94.2673 96.1782 98.0891 100.0000];
mesh.x=[0.0000 1.8753 3.7505 5.6258 7.5010 9.3763 11.2515 13.1268 15.0020 16.8773 18.7525 20.6278 22.5030 24.3783 26.2535 28.1288 30.0041 30.5041 30.5041 30.9902 31.4763 31.9624 32.4485 32.9346 33.4207 33.9068 34.3929 34.8791 35.3652 35.8513 36.3374 36.3374 36.8352 37.3330 37.8308 38.3286 38.8264 39.3242 39.8220 40.3198 40.8177 41.3155 41.8133 42.3111 42.8089 43.3067 43.8045 44.3023 44.8001 45.2979 45.7957 46.2935 46.7913 47.2891 47.7870 48.2848 48.7826 49.2804 49.7782 50.2760 50.7738 51.2716 51.7694 52.2672 52.7650 53.2628 53.7606 54.2584 54.7563 55.2541 55.7519 56.2497 56.7475 57.2453 57.7431 58.2409 58.7387 59.2365 59.7343 60.2321 60.7299 61.2277 61.7255 62.2234 62.7212 63.2190 63.7168 64.2146 64.7124 65.2102 65.7080 66.2058 66.7036 67.2014 67.6992 68.1970 68.6948 69.1927 69.6905 70.1883 70.6861 71.1839 71.6817 72.1795 72.6773 73.1751 73.6729 74.1707 74.6707 74.6707 76.6228 78.5749 80.5270 82.4791 84.4312 86.3833 88.3354 90.2875 92.2395 94.1916 96.1437 98.0958 100.0479 102.0000];
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
outline_xy(1, 2) = 102.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 102.0000; outline_xy(2, 3) = -100.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -100.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 3, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 102.0000; poly0_xy(2, 1) = 0.0000;
poly0_xy(1, 2) = 102.0000; poly0_xy(2, 2) = -100.0000;
poly0_xy(1, 3) = 0.0000; poly0_xy(2, 3) = -100.0000;
poly0_xy(1, 4) = 0.0000; poly0_xy(2, 4) = 0.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 4, poly0_xy, 1);
poly1_xy(1, 1) = 74.3374; poly1_xy(2, 1) = -24.9924;
poly1_xy(1, 2) = 74.3374; poly1_xy(2, 2) = -58.0924;
poly1_xy(1, 3) = 63.3374; poly1_xy(2, 3) = -69.0924;
poly1_xy(1, 4) = 52.2443; poly1_xy(2, 4) = -69.0924;
poly1_xy(1, 5) = 52.2443; poly1_xy(2, 5) = -49.7219;
poly1_xy(1, 6) = 57.9365; poly1_xy(2, 6) = -55.4141;
poly1_xy(1, 7) = 60.6942; poly1_xy(2, 7) = -52.6564;
poly1_xy(1, 8) = 52.2443; poly1_xy(2, 8) = -44.2064;
poly1_xy(1, 9) = 52.2443; poly1_xy(2, 9) = -24.9924;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 41.3374; poly2_xy(2, 1) = -24.9924;
poly2_xy(1, 2) = 52.2443; poly2_xy(2, 2) = -24.9924;
poly2_xy(1, 3) = 52.2443; poly2_xy(2, 3) = -44.2064;
poly2_xy(1, 4) = 46.6228; poly2_xy(2, 4) = -38.5849;
poly2_xy(1, 5) = 43.7944; poly2_xy(2, 5) = -41.4134;
poly2_xy(1, 6) = 43.9358; poly2_xy(2, 6) = -41.4134;
poly2_xy(1, 7) = 52.2443; poly2_xy(2, 7) = -49.7219;
poly2_xy(1, 8) = 52.2443; poly2_xy(2, 8) = -69.0924;
poly2_xy(1, 9) = 30.3374; poly2_xy(2, 9) = -69.0924;
poly2_xy(1, 10) = 30.3374; poly2_xy(2, 10) = -35.9924;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
poly3_xy(1, 1) = 74.3374; poly3_xy(2, 1) = -24.9924;
poly3_xy(1, 2) = 74.3374; poly3_xy(2, 2) = -58.0924;
poly3_xy(1, 3) = 63.3374; poly3_xy(2, 3) = -69.0924;
poly3_xy(1, 4) = 52.2443; poly3_xy(2, 4) = -69.0924;
poly3_xy(1, 5) = 52.2443; poly3_xy(2, 5) = -49.7219;
poly3_xy(1, 6) = 57.9365; poly3_xy(2, 6) = -55.4141;
poly3_xy(1, 7) = 60.6942; poly3_xy(2, 7) = -52.6564;
poly3_xy(1, 8) = 52.2443; poly3_xy(2, 8) = -44.2064;
poly3_xy(1, 9) = 52.2443; poly3_xy(2, 9) = -24.9924;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly3_xy, 1);
poly4_xy(1, 1) = 41.3374; poly4_xy(2, 1) = -24.9924;
poly4_xy(1, 2) = 52.2443; poly4_xy(2, 2) = -24.9924;
poly4_xy(1, 3) = 52.2443; poly4_xy(2, 3) = -44.2064;
poly4_xy(1, 4) = 46.6228; poly4_xy(2, 4) = -38.5849;
poly4_xy(1, 5) = 43.7944; poly4_xy(2, 5) = -41.4134;
poly4_xy(1, 6) = 43.9358; poly4_xy(2, 6) = -41.4134;
poly4_xy(1, 7) = 52.2443; poly4_xy(2, 7) = -49.7219;
poly4_xy(1, 8) = 52.2443; poly4_xy(2, 8) = -69.0924;
poly4_xy(1, 9) = 30.3374; poly4_xy(2, 9) = -69.0924;
poly4_xy(1, 10) = 30.3374; poly4_xy(2, 10) = -35.9924;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly4_xy, 1);
poly5_xy(1, 1) = 35.8374; poly5_xy(2, 1) = -46.5924;
poly5_xy(1, 2) = 35.8374; poly5_xy(2, 2) = -47.5924;
poly5_xy(1, 3) = 36.8374; poly5_xy(2, 3) = -47.5924;
poly5_xy(1, 4) = 36.8374; poly5_xy(2, 4) = -46.5924;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly5_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 36.3374; point1(2, 1) = -47.0924;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 4);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);
