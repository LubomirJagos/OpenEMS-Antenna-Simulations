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
z_bottom_copper=1.5000
mesh.y=[4.2365 3.4865 0.0000 0.6973 1.3946 2.0919 2.7892 4.7365 5.2365 5.2365 5.6445 6.0525 6.4605 6.8685 7.2765 7.2765 7.4432 7.7765 7.7765 7.9432 7.9432 8.4378 8.9325 9.4272 9.9218 10.4165 10.9112 11.4058 11.9005 12.3952 12.8898 13.3845 13.8792 14.3738 14.8685 15.3632 15.8578 16.3525 16.8472 17.3418 17.8365 18.3312 18.8258 19.3205 19.8152 20.3098 20.8045 21.2992 21.7938 22.2885 22.7832 23.2778 23.7725 24.2672 24.7618 25.2565 25.7511 26.2458 26.7405 27.2351 27.7298 28.2245 28.7191 29.2138 29.7085 30.2031 30.6978 31.1925 31.6871 32.1818 32.6765 32.8432 32.8432 33.1765 33.3432 33.3432 33.3432 33.7512 34.1592 34.5672 34.9752 35.3832 35.8832 35.8832 36.2554 36.6277 37.0000 37.9232 38.4232 38.4232 38.9232 39.6732 40.3745 41.0759 41.7773 42.4786 43.1800];
mesh.x=[6.4527 5.7027 0.0000 0.7128 1.4257 2.1385 2.8513 3.5642 4.2770 4.9898 6.9527 7.4527 7.4527 7.8184 8.1842 8.5500 8.5500 8.9343 9.3187 9.7030 10.2030 10.2030 10.6531 11.1031 11.5532 12.0033 12.4533 12.9533 12.9533 13.4084 13.8636 14.3187 14.8187 14.8187 15.2600 15.7013 16.1427 16.5840 17.0253 17.5253 18.8907 19.3907 19.3907 19.8320 20.2733 20.7147 21.1560 21.5973 22.0973 22.0973 22.5524 23.0076 23.4627 23.9627 23.9627 24.4040 24.8453 25.2867 25.7280 26.1693 26.6693 28.0347 28.5347 28.5347 28.9760 29.4173 29.8587 30.3000 30.7413 31.2413 31.2413 31.6964 32.1516 32.6067 33.1067 33.1067 33.5567 34.0068 34.4569 34.9069 35.3570 35.8570 35.8570 36.2380 36.6190 37.0000 37.0000 37.3691 37.7382 38.1073 38.6073 38.6073 39.1073 39.8573 40.5806 41.3039 42.0273 42.7506 43.4739 44.1972 44.9205 45.6438];
mesh.z=[0.0000 0.3750 0.7500 1.1250 1.5000 -3.0000 -2.4000 -1.8000 -1.2000 -0.6000 1.5000 2.1000 2.7000 3.3000 3.9000];
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
layer_types(1).thickness = 0.07/1000;
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
layers(3).name = 'bottom_copper';
layers(3).clearn = 0;
layer_types(3).name = 'COPPER_3';
layer_types(3).subtype = 2;
layer_types(3).thickness = 0.07/1000;
layer_types(3).conductivity = 56*10^6;


%%% Initialize pcb2csx
PCBRND = InitPCBRND(layers, layer_types, void, base_priority, offset, kludge);
CSX = InitPcbrndLayers(CSX, PCBRND);

%%% Board outline
outline_xy(1, 1) = 0; outline_xy(2, 1) = 0;
outline_xy(1, 2) = 45.6438; outline_xy(2, 2) = 0;
outline_xy(1, 3) = 45.6438; outline_xy(2, 3) = -43.1800;
outline_xy(1, 4) = 0; outline_xy(2, 4) = -43.1800;
CSX = AddPcbrndPoly(CSX, PCBRND, 2, outline_xy, 1);

%%% Copper objects
poly0_xy(1, 1) = 44.6278; poly0_xy(2, 1) = -42.1538;
poly0_xy(1, 2) = 1.0160; poly0_xy(2, 2) = -42.1538;
poly0_xy(1, 3) = 1.0160; poly0_xy(2, 3) = -1.0160;
poly0_xy(1, 4) = 44.6278; poly0_xy(2, 4) = -1.0160;
CSX = AddPcbrndPoly(CSX, PCBRND, 3, poly0_xy, 1);
poly1_xy(1, 1) = 35.4800; poly1_xy(2, 1) = -33.0098;
poly1_xy(1, 2) = 32.9400; poly1_xy(2, 2) = -33.0098;
poly1_xy(1, 3) = 32.9400; poly1_xy(2, 3) = -7.6098;
poly1_xy(1, 4) = 30.9080; poly1_xy(2, 4) = -7.6098;
poly1_xy(1, 5) = 30.9080; poly1_xy(2, 5) = -33.0098;
poly1_xy(1, 6) = 28.3680; poly1_xy(2, 6) = -33.0098;
poly1_xy(1, 7) = 28.3680; poly1_xy(2, 7) = -7.6098;
poly1_xy(1, 8) = 30.9080; poly1_xy(2, 8) = -5.0698;
poly1_xy(1, 9) = 32.9400; poly1_xy(2, 9) = -5.0698;
poly1_xy(1, 10) = 35.4800; poly1_xy(2, 10) = -7.6098;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly1_xy, 1);
poly2_xy(1, 1) = 19.2240; poly2_xy(2, 1) = -7.6098;
poly2_xy(1, 2) = 21.7640; poly2_xy(2, 2) = -7.6098;
poly2_xy(1, 3) = 21.7640; poly2_xy(2, 3) = -33.0098;
poly2_xy(1, 4) = 23.7960; poly2_xy(2, 4) = -33.0098;
poly2_xy(1, 5) = 23.7960; poly2_xy(2, 5) = -7.6098;
poly2_xy(1, 6) = 26.3360; poly2_xy(2, 6) = -7.6098;
poly2_xy(1, 7) = 26.3360; poly2_xy(2, 7) = -33.0098;
poly2_xy(1, 8) = 23.7960; poly2_xy(2, 8) = -35.5498;
poly2_xy(1, 9) = 21.7640; poly2_xy(2, 9) = -35.5498;
poly2_xy(1, 10) = 19.2240; poly2_xy(2, 10) = -33.0098;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
poly3_xy(1, 1) = 17.1920; poly3_xy(2, 1) = -33.0098;
poly3_xy(1, 2) = 14.6520; poly3_xy(2, 2) = -33.0098;
poly3_xy(1, 3) = 14.6520; poly3_xy(2, 3) = -7.6098;
poly3_xy(1, 4) = 12.6200; poly3_xy(2, 4) = -7.6098;
poly3_xy(1, 5) = 12.6200; poly3_xy(2, 5) = -33.0098;
poly3_xy(1, 6) = 10.0800; poly3_xy(2, 6) = -33.0098;
poly3_xy(1, 7) = 10.0800; poly3_xy(2, 7) = -7.6098;
poly3_xy(1, 8) = 12.6200; poly3_xy(2, 8) = -5.0698;
poly3_xy(1, 9) = 14.6520; poly3_xy(2, 9) = -5.0698;
poly3_xy(1, 10) = 17.1920; poly3_xy(2, 10) = -7.6098;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly3_xy, 1);
poly4_xy(1, 1) = 9.8260; poly4_xy(2, 1) = -38.0898;
poly4_xy(1, 2) = 7.2860; poly4_xy(2, 2) = -38.0898;
poly4_xy(1, 3) = 7.2860; poly4_xy(2, 3) = -7.6098;
poly4_xy(1, 4) = 9.8260; poly4_xy(2, 4) = -7.6098;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly4_xy, 1);
poly5_xy(1, 1) = 38.2740; poly5_xy(2, 1) = -38.0898;
poly5_xy(1, 2) = 35.7340; poly5_xy(2, 2) = -38.0898;
poly5_xy(1, 3) = 35.7340; poly5_xy(2, 3) = -7.6098;
poly5_xy(1, 4) = 38.2740; poly5_xy(2, 4) = -7.6098;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly5_xy, 1);
poly6_xy(1, 1) = 8.0500; poly6_xy(2, 1) = -36.5000;
poly6_xy(1, 2) = 9.0500; poly6_xy(2, 2) = -36.5000;
poly6_xy(1, 3) = 9.0500; poly6_xy(2, 3) = -37.5000;
poly6_xy(1, 4) = 8.0500; poly6_xy(2, 4) = -37.5000;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly6_xy, 1);
poly7_xy(1, 1) = 36.5000; poly7_xy(2, 1) = -36.5000;
poly7_xy(1, 2) = 37.5000; poly7_xy(2, 2) = -36.5000;
poly7_xy(1, 3) = 37.5000; poly7_xy(2, 3) = -37.5000;
poly7_xy(1, 4) = 36.5000; poly7_xy(2, 4) = -37.5000;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly7_xy, 1);
%%% Port(s) on terminals

point1(1, 1) = 8.5500; point1(2, 1) = -37.0000;
[start1, stop1] = CalcPcbrnd2PortV(PCBRND, point1, 1, 3);
[CSX, port{1}] = AddLumpedPort(CSX, 999, 1, 50.000000, start1, stop1, [0 0 -1], true);

point2(1, 1) = 37.0000; point2(2, 1) = -37.0000;
[start2, stop2] = CalcPcbrnd2PortV(PCBRND, point2, 1, 3);
[CSX, port{2}] = AddLumpedPort(CSX, 999, 2, 50.000000, start2, stop2, [0 0 -1]);
