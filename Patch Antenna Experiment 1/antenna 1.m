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
mesh.y=[110.4783 108.5450 105.8283 102.3283 0.0000 3.4109 6.8219 10.2328 13.6438 17.0547 20.4657 23.8766 27.2876 30.6985 34.1094 37.5204 40.9313 44.3423 47.7532 51.1642 54.5751 57.9860 61.3970 64.8079 68.2189 71.6298 75.0408 78.4517 81.8627 85.2736 88.6845 92.0955 95.5064 98.9174 111.6283 112.7783 112.7783 113.9187 115.0591 116.1994 117.3398 118.4802 119.6205 120.7609 121.9013 123.0416 124.1820 125.3224 126.4627 127.6031 128.7435 129.8838 131.0242 132.1646 133.3049 134.4453 135.5857 136.7260 137.8664 139.0068 140.1471 141.2875 142.4278 143.5682 144.7086 145.8489 146.9893 148.1297 149.2700 150.4104 151.5508 152.6911 153.8315 154.9719 156.1122 157.2526 158.3930 159.5333 160.6737 161.8141 162.9544 164.0948 165.2352 166.3755 167.5159 168.6563 169.7967 170.4317 170.9467 171.5817 171.5817 172.6285 173.6754 174.7223 175.7692 176.8160 177.8629 178.9098 179.9567 181.1067 181.1067 182.2299 183.3532 184.4764 185.5997 186.7229 187.8461 188.9694 190.0926 191.2159 192.3391 193.4624 194.5856 195.7089 196.8321 197.9554 199.0786 200.2019 201.3251 202.4484 203.5716 204.6949 205.8181 206.9413 208.0646 209.1878 210.3111 211.4343 212.5576 213.6808 214.8041 215.9273 217.0506 218.1738 219.2971 220.4203 221.5703 221.5703 222.5953 223.6202 224.6451 225.6701 226.6950 226.6950 227.7104 228.7258 229.7412 230.7567 231.8632 232.9697 232.9697 234.1197 236.0530 238.7697 242.2697 245.6656 249.0615 252.4574 255.8533 259.2492 262.6451 266.0410 269.4369 272.8328 276.2287 279.6246 283.0205 286.4164 289.8123 293.2082 296.6041 300.0000];
mesh.x=[72.3783 70.4450 67.7283 64.2283 0.0000 3.3804 6.7609 10.1413 13.5218 16.9022 20.2826 23.6631 27.0435 30.4239 33.8044 37.1848 40.5653 43.9457 47.3261 50.7066 54.0870 57.4674 60.8479 73.5283 74.6783 74.6783 75.8283 76.9783 78.1282 79.2782 80.4282 81.5781 82.7281 83.8781 85.0281 86.1780 87.3280 88.4780 89.6279 90.7779 91.9279 93.0778 94.2278 95.3778 96.5277 97.6777 98.8277 99.9777 101.1276 102.2776 103.4276 104.5775 105.7275 106.8775 108.0274 109.1774 110.3274 111.4773 112.6273 113.7773 114.9272 116.0772 117.2272 118.3772 119.5271 120.6771 121.8271 122.9770 124.1270 125.2770 126.4269 127.5769 128.7269 129.8768 131.0268 132.1768 133.3268 134.4767 135.6267 136.7767 137.9267 138.5053 139.6118 139.9517 140.7183 141.1017 141.1017 142.0212 142.9408 143.8604 144.7800 144.7800 145.7193 146.6587 147.5980 148.5373 149.4767 150.6267 152.9033 154.0533 154.0533 155.1873 156.3213 157.4553 158.5894 159.7234 160.8574 161.9914 163.1254 164.2594 165.3934 166.5274 167.6614 168.7954 169.9294 171.0634 172.1974 173.3314 174.4654 175.5994 176.7334 177.8674 179.0014 180.1354 181.2695 182.4035 183.5375 184.6715 185.8055 186.9395 188.0735 189.2075 190.3415 191.4755 192.6095 193.7435 194.8775 196.0115 197.1455 198.2795 199.4135 200.5475 201.6815 202.8155 203.9496 205.0836 206.2176 207.3516 208.4856 209.6196 210.7536 211.8876 213.0216 214.1556 215.2896 216.4236 217.5576 218.6917 219.8417 219.8417 220.9917 222.9250 225.6417 229.1417 232.5159 235.8901 239.2643 242.6385 246.0127 249.3869 252.7611 256.1353 259.5095 262.8837 266.2579 269.6321 273.0063 276.3805 279.7548 283.1290 286.5032 289.8774 293.2516 296.6258 300.0000];
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
poly0_xy(1, 1) = 253.3650; poly0_xy(2, 1) = -85.0900;
poly0_xy(1, 2) = 253.3650; poly0_xy(2, 2) = -250.8250;
poly0_xy(1, 3) = 41.9100; poly0_xy(2, 3) = -250.8250;
poly0_xy(1, 4) = 41.9100; poly0_xy(2, 4) = -85.0900;
poly0_xy(1, 5) = 40.6400; poly0_xy(2, 5) = -85.0900;
CSX = AddPcbrndPoly(CSX, PCBRND, 7, poly0_xy, 1);
poly1_xy(1, 1) = 144.2800; poly1_xy(2, 1) = -226.1950;
poly1_xy(1, 2) = 144.2800; poly1_xy(2, 2) = -227.1950;
poly1_xy(1, 3) = 145.2800; poly1_xy(2, 3) = -227.1950;
poly1_xy(1, 4) = 145.2800; poly1_xy(2, 4) = -226.1950;
CSX = AddPcbrndPoly(CSX, PCBRND, 7, poly1_xy, 1);
poly2_xy(1, 1) = 140.3350; poly2_xy(2, 1) = -170.1800;
poly2_xy(1, 2) = 137.1600; poly2_xy(2, 2) = -170.1800;
poly2_xy(1, 3) = 137.1600; poly2_xy(2, 3) = -180.3400;
poly2_xy(1, 4) = 74.2950; poly2_xy(2, 4) = -180.3400;
poly2_xy(1, 5) = 74.2950; poly2_xy(2, 5) = -112.3950;
poly2_xy(1, 6) = 219.0750; poly2_xy(2, 6) = -112.3950;
poly2_xy(1, 7) = 219.0750; poly2_xy(2, 7) = -180.3400;
poly2_xy(1, 8) = 153.6700; poly2_xy(2, 8) = -180.3400;
poly2_xy(1, 9) = 153.6700; poly2_xy(2, 9) = -170.8150;
poly2_xy(1, 10) = 149.8600; poly2_xy(2, 10) = -170.8150;
poly2_xy(1, 11) = 149.8600; poly2_xy(2, 11) = -231.1400;
poly2_xy(1, 12) = 140.3350; poly2_xy(2, 12) = -231.1400;
poly2_xy(1, 13) = 140.3350; poly2_xy(2, 13) = -232.2030;
poly2_xy(1, 14) = 139.2720; poly2_xy(2, 14) = -232.2030;
poly2_xy(1, 15) = 139.2720; poly2_xy(2, 15) = -221.1870;
poly2_xy(1, 16) = 140.3350; poly2_xy(2, 16) = -221.1870;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly2_xy, 1);
poly3_xy(1, 1) = 144.2800; poly3_xy(2, 1) = -226.1950;
poly3_xy(1, 2) = 144.2800; poly3_xy(2, 2) = -227.1950;
poly3_xy(1, 3) = 145.2800; poly3_xy(2, 3) = -227.1950;
poly3_xy(1, 4) = 145.2800; poly3_xy(2, 4) = -226.1950;
CSX = AddPcbrndPoly(CSX, PCBRND, 1, poly3_xy, 1);
%%% Port(s) on terminals
