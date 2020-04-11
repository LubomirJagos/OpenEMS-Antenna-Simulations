addpath('C:\Users\H364387\Documents\Octave\STLread_for_Octave');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CONSTANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsilon_substrate = 3.66;
%mue_substrate = 1; %not used
fmax = 6e9;
fc = 6e9;
f0 = 0;
NumberOfTimesteps = 60000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assuming you have a file "sample.stl"
%[vertices, faces, c] = stlread('antenna.stl');
%[vertices, faces, c] = stlread('gnd.stl');
%[vertices, faces, c] = stlread('substrate.stl');
%[vertices, faces, c] = stlread('air.stl');

simFiles = [
  "antenna.stl",
  "substrate.stl",
  "excitation.stl",
  "gnd.stl",
  "air.stl"
];

xlines = [];
ylines = [];
zlines = [];
xmlOutput = "";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate start of file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>' "\n"];
xmlOutput = [xmlOutput '<openEMS>' "\n"];
xmlOutput = [xmlOutput '  <FDTD NumberOfTimesteps="' num2str(NumberOfTimesteps) '" endCriteria="1e-05" f_max="' num2str(fmax) '">' "\n"];
xmlOutput = [xmlOutput '    <Excitation Type="0" f0="' num2str(f0) '" fc="' num2str(fc) '">' "\n"];
xmlOutput = [xmlOutput '    </Excitation>' "\n"];
xmlOutput = [xmlOutput '    <BoundaryCond xmin="MUR" xmax="MUR" ymin="MUR" ymax="MUR" zmin="MUR" zmax="MUR">' "\n"];
xmlOutput = [xmlOutput '    </BoundaryCond>' "\n"];
xmlOutput = [xmlOutput '  </FDTD>' "\n"];
xmlOutput = [xmlOutput '  <ContinuousStructure CoordSystem="0">' "\n"];
xmlOutput = [xmlOutput '    <Properties>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Go through iles and generate grid lines positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stlFile = simFiles(1, :);
stlFileName = substr(strtrim(stlFile), 1, size(strtrim(stlFile))(2) - 4);
display(["Read file: " stlFile]);
[vertices, faces, c] = stlread(stlFile);

stlFile2 = simFiles(3, :);
stlFileName2 = substr(strtrim(stlFile2), 1, size(strtrim(stlFile2))(2) - 4);
display(["Read file: " stlFile2]);
[vertices2, faces2, c2] = stlread(stlFile2);

maxX = max(vertices(:,1));
minX = min(vertices(:,1));
maxY = max(vertices(:,2));
minY = min(vertices(:,2));
maxZ = max(vertices(:,3));
minZ = min(vertices(:,3));

%display(num2str(maxX));
display([num2str(minX) " " num2str(maxX) "       " num2str(maxX - minX)]);
display([num2str(minY) " " num2str(maxY) "       " num2str(maxY - minY)]);
display([num2str(minZ) " " num2str(maxZ) "       " num2str(maxZ - minZ)]);
display("================================================================== \n");
  
  plot(vertices(:,1), vertices(:,2)); hold on;
  plot(vertices2(:,1), vertices2(:,2));
