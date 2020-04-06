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
mesh.y=[48.3950 47.8117 46.9450 45.7950 44.3617 42.6450 40.6450 0.0000 1.9355 3.8710 5.8064 7.7419 9.6774 11.6129 13.5483 15.4838 17.4193 19.3548 21.2902 23.2257 25.1612 27.0967 29.0321 30.9676 32.9031 34.8386 36.7740 38.7095 48.6950 48.9950 48.9950 49.2661 49.5372 49.8083 50.0794 50.3506 50.6217 50.8928 51.1639 51.4350 51.4350 51.6467 51.8583 52.0700 52.0700 52.3655 52.6611 52.9566 53.2521 53.5476 53.8432 54.1387 54.4342 54.7297 55.0253 55.3208 55.6163 55.9118 56.2074 56.5029 56.7984 57.0939 57.3895 57.6850 57.9850 57.9850 59.8196 61.6542 63.4887 65.3233 67.1579 68.9925 70.8271 72.6617 74.4962 76.3308 78.1654 80.0000];
mesh.x=[0.0000 1.9385 3.8769 5.8154 7.7538 9.6923 11.6308 13.5692 15.5077 17.4461 19.3846 21.3231 23.2615 25.2000 25.5000 25.5000 25.7951 26.0902 26.3853 26.6804 26.9755 27.2706 27.5657 27.8608 28.1560 28.4511 28.7462 29.0413 29.3364 29.6315 29.9266 30.2217 30.5168 30.8119 31.1070 31.4021 31.6972 31.9923 32.2874 32.5825 32.8777 33.1728 33.4679 33.7630 34.0581 34.3532 34.6483 34.9434 35.2385 35.5336 35.8287 36.1238 36.4189 36.7140 37.0091 37.3042 37.5993 37.8945 38.1896 38.4847 38.7798 39.0749 39.3700 39.3700 39.6586 39.9473 40.2359 40.5245 40.8132 41.1018 41.3905 41.6791 41.9677 42.2564 42.5450 42.5450 42.8391 43.1332 43.4273 43.7214 44.0156 44.3097 44.6038 44.8979 45.1920 45.4861 45.7802 46.0743 46.3684 46.6626 46.9567 47.2508 47.5449 47.8390 48.1331 48.4272 48.7213 49.0154 49.3096 49.6037 49.8978 50.1919 50.4860 50.7801 51.0742 51.3683 51.6624 51.9566 52.2507 52.5448 52.8389 53.1330 53.4271 53.7212 54.0153 54.3094 54.6036 54.8977 55.1918 55.4859 55.7800 56.0800 56.0800 58.0733 60.0667 62.0600 64.0533 66.0467 68.0400 70.0333 72.0267 74.0200 76.0133 78.0067 80.0000];
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
outline_xy(1, 2) = 80.0000; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 80.0000; outline_xy(2, 3) = -80.0000;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -80.0000;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 4, outline_xy, 1);
CSX = AddPcbrndPoly(CSX, PCBRND, 6, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 61.5950; poly0_xy(2, 1) = -23.4950;
poly0_xy(1, 2) = 61.5950; poly0_xy(2, 2) = -62.8650;
poly0_xy(1, 3) = 19.0500; poly0_xy(2, 3) = -62.8650;
poly0_xy(1, 4) = 19.0500; poly0_xy(2, 4) = -23.4950;
CSX = AddPcbrndPoly(CSX, PCBRND, 7, poly0_xy, 1);
poly1_xy(1, 1) = 55.8800; poly1_xy(2, 1) = -48.8950;
poly1_xy(1, 2) = 55.8800; poly1_xy(2, 2) = -57.7850;
poly1_xy(1, 3) = 25.4000; poly1_xy(2, 3) = -57.7850;
poly1_xy(1, 4) = 25.4000; poly1_xy(2, 4) = -48.8950;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 38.8700; poly2_xy(2, 1) = -50.9350;
poly2_xy(1, 2) = 38.8700; poly2_xy(2, 2) = -51.9350;
poly2_xy(1, 3) = 39.8700; poly2_xy(2, 3) = -51.9350;
poly2_xy(1, 4) = 39.8700; poly2_xy(2, 4) = -50.9350;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
poly3_xy(1, 1) = 42.0450; poly3_xy(2, 1) = -51.5700;
poly3_xy(1, 2) = 42.0450; poly3_xy(2, 2) = -52.5700;
poly3_xy(1, 3) = 43.0450; poly3_xy(2, 3) = -52.5700;
poly3_xy(1, 4) = 43.0450; poly3_xy(2, 4) = -51.5700;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly3_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 39.3700; point1(2, 1) = -51.4350;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 3);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);

point2(1, 1) = 42.5450; point2(2, 1) = -52.0700;
[start2, stop2] = CalcPcbrnd2PortV(PCBRND, point2, 1, 3);
[CSX, port{2}] = AddLumpedPort(CSX, 999, 2, 50.000000, start2, stop2, [0 0 -1]);
