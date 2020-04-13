addpath('C:\Users\H364387\Documents\Octave\STLread_for_Octave');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CONSTANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir('tmp');
outputFileName = './tmp/csxcad.xml';

epsilon_substrate = 3.66;
fmax = 8e9;
%mue_substrate = 1; %not used
f0 = 0e9;
fc = 4e9;
input1_resistance = 50;
NumberOfTimesteps = 15e3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assuming you have a file "sample.stl"
%[vertices, faces, c] = stlread('antenna.stl');
%[vertices, faces, c] = stlread('gnd.stl');
%[vertices, faces, c] = stlread('substrate.stl');
%[vertices, faces, c] = stlread('air.stl');

coords = {};  %structure to store XYZ coordination of each structure in model

simFiles = [
  "antenna.stl",
  "excitationCoax.stl",
  "gnd.stl",
  "currentProbe_i1_A.stl",
  "currentProbe_i1_B.stl",
  "currentProbe_i2_A.stl",
  "currentProbe_i2_B.stl",
  "voltageProbe_u1_A.stl",
  "voltageProbe_u1_B.stl",
  "voltageProbe_u1_C.stl",
  "voltageProbe_u2_A.stl",
  "voltageProbe_u2_B.stl",
  "voltageProbe_u2_C.stl"
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
xmlOutput = [xmlOutput '    <BoundaryCond xmin="PEC" xmax="PEC" ymin="PEC" ymax="PEC" zmin="PML_8" zmax="PML_8">' "\n"];
xmlOutput = [xmlOutput '    </BoundaryCond>' "\n"];
xmlOutput = [xmlOutput '  </FDTD>' "\n"];
xmlOutput = [xmlOutput '  <ContinuousStructure CoordSystem="0">' "\n"];
xmlOutput = [xmlOutput '    <Properties>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Go through iles and generate grid lines positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:size(simFiles)
  stlFile = simFiles(k, :);
  stlFileName = substr(strtrim(stlFile), 1, size(strtrim(stlFile))(2) - 4);

  display(["Read file: " stlFile]);
  [vertices, faces, c] = stlread(stlFile);

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
  
  if strncmp(stlFile, 'antenna.stl', 4) == 1
    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <Metal Name="' stlFileName '">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <PolyhedronReader Priority="10" FileName="' pwd() '\' stlFile '" FileType="STL">' "\n"];
    xmlOutput = [xmlOutput '            <Transformation>' "\n"];
    xmlOutput = [xmlOutput '              <Scale Argument="1">' "\n"];
    xmlOutput = [xmlOutput '              </Scale>' "\n"];
    xmlOutput = [xmlOutput '            </Transformation>' "\n"];
    xmlOutput = [xmlOutput '          </PolyhedronReader>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </Metal>' "\n"];
  elseif strncmp(stlFile, 'gnd.stl', 4) == 1
    coords.gnd.minX = minX;
    coords.gnd.maxX = maxX;
    coords.gnd.minY = minY;
    coords.gnd.maxY = maxY;
    coords.gnd.minZ = minZ;
    coords.gnd.maxZ = maxZ;

    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <Metal Name="' stlFileName '">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <PolyhedronReader Priority="10" FileName="' pwd() '\' stlFile '" FileType="STL">' "\n"];
    xmlOutput = [xmlOutput '            <Transformation>' "\n"];
    xmlOutput = [xmlOutput '              <Scale Argument="1">' "\n"];
    xmlOutput = [xmlOutput '              </Scale>' "\n"];
    xmlOutput = [xmlOutput '            </Transformation>' "\n"];
    xmlOutput = [xmlOutput '          </PolyhedronReader>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </Metal>' "\n"];
  elseif strncmp(stlFile, 'air.stl', 4) == 1    
    coords.air.minX = minX;
    coords.air.maxX = maxX;
    coords.air.minY = minY;
    coords.air.maxY = maxY;
    coords.air.minZ = minZ;
    coords.air.maxZ = maxZ;

    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <Material Name="' stlFileName '">' "\n"];
    xmlOutput = [xmlOutput '        <Property Epsilon="1" Mue="1" kappa="0">' "\n"];
    xmlOutput = [xmlOutput '        </Property>' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <PolyhedronReader Priority="10" FileName="' pwd() '\' stlFile '" FileType="STL">' "\n"];
    xmlOutput = [xmlOutput '            <Transformation>' "\n"];
    xmlOutput = [xmlOutput '              <Scale Argument="1">' "\n"];
    xmlOutput = [xmlOutput '              </Scale>' "\n"];
    xmlOutput = [xmlOutput '            </Transformation>' "\n"];
    xmlOutput = [xmlOutput '          </PolyhedronReader>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </Material>' "\n"];
  elseif strncmp(stlFile, 'substrate.stl', 4) == 1
    coords.substrate.minX = minX;
    coords.substrate.maxX = maxX;
    coords.substrate.minY = minY;
    coords.substrate.maxY = maxY;
    coords.substrate.minZ = minZ;
    coords.substrate.maxZ = maxZ;

    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <Material Name="' stlFileName '">' "\n"];
    xmlOutput = [xmlOutput '        <Property Epsilon="' num2str(epsilon_substrate) '">' "\n"];
    xmlOutput = [xmlOutput '        </Property>' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <PolyhedronReader Priority="10" FileName="' pwd() '\' stlFile '" FileType="STL">' "\n"];
    xmlOutput = [xmlOutput '            <Transformation>' "\n"];
    xmlOutput = [xmlOutput '              <Scale Argument="1">' "\n"];
    xmlOutput = [xmlOutput '              </Scale>' "\n"];
    xmlOutput = [xmlOutput '            </Transformation>' "\n"];
    xmlOutput = [xmlOutput '          </PolyhedronReader>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </Material>' "\n"];
  elseif strncmp(stlFile, 'excitationCoax', 12) == 1

      minD = 100;
      maxD = 230;
      
      minR = minD/2;
      maxR = maxD/2;
      radius = (maxD + minD)/4;
      shellWidth = (maxR - minR);
      
      if (abs(minZ - maxZ) ~= 0)
        xmlOutput = [xmlOutput '<Excitation Name="port_excite_1" Type="0" Excite="1,1,0">'];
        xmlOutput = [xmlOutput '  <Weight X="(x-0)/((x-0)*(x-0)+(y-0)*(y-0)) * (sqrt((x-0)*(x-0)+(y-0)*(y-0))<' num2str(maxR) ') * (sqrt((x-0)*(x-0)+(y-0)*(y-0))>' num2str(minR) ')" Y="(y-0)/((x-0)*(x-0)+(y-0)*(y-0)) * (sqrt((x-0)*(x-0)+(y-0)*(y-0))<' num2str(maxR) ') * (sqrt((x-0)*(x-0)+(y-0)*(y-0))>' num2str(minR) ')" Z="0">'];
        xmlOutput = [xmlOutput '  </Weight>'];
        xmlOutput = [xmlOutput '  <Primitives>'];
        xmlOutput = [xmlOutput '    <CylindricalShell Priority="0" Radius="' num2str(radius) '" ShellWidth="' num2str(shellWidth) '">'];
        xmlOutput = [xmlOutput '      <P1 X="0" Y="0" Z="' num2str(maxZ) '">'];
        xmlOutput = [xmlOutput '      </P1>'];
        xmlOutput = [xmlOutput '      <P2 X="0" Y="0" Z="' num2str(minZ) '">'];
        xmlOutput = [xmlOutput '      </P2>'];
        xmlOutput = [xmlOutput '    </CylindricalShell>'];
        xmlOutput = [xmlOutput '  </Primitives>'];
        xmlOutput = [xmlOutput '</Excitation>'];
    else
%here will be generate rectangle box with excitation if there is non zero height
    
%      xmlOutput = [xmlOutput '      <Excitation Name="' stlFileName '" Type="0" Excite="0,0,-1">' "\n"];
%      xmlOutput = [xmlOutput '        <Primitives>' "\n"];
%      xmlOutput = [xmlOutput '          <Box Priority="999">' "\n"];
%      xmlOutput = [xmlOutput '            <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str(maxZ) '">' "\n"];
%      xmlOutput = [xmlOutput '            </P1>' "\n"];
%      xmlOutput = [xmlOutput '            <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str(minZ) '">' "\n"];
%      xmlOutput = [xmlOutput '            </P2>' "\n"];
%      xmlOutput = [xmlOutput '          </Box>' "\n"];
%      xmlOutput = [xmlOutput '        </Primitives>' "\n"];
%      xmlOutput = [xmlOutput '      </Excitation>' "\n"];
    endif
    
  elseif strncmp(stlFile, 'currentProbe', 10) == 1
    zlines = [zlines linspace(minZ, maxZ, 3)];  %added extra mesh lines for current probes to match their Z coords

    zcoord = minZ;  %current probe is in one level
    
    xmlOutput = [xmlOutput '<ProbeBox Name="' stlFileName '" Type="1" Weight="-1">'];
    xmlOutput = [xmlOutput '  <Primitives>'];
    xmlOutput = [xmlOutput '    <Box Priority="999">'];
    xmlOutput = [xmlOutput '      <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str(zcoord) '">'];
    xmlOutput = [xmlOutput '      </P1>'];
    xmlOutput = [xmlOutput '      <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str(zcoord) '">'];
    xmlOutput = [xmlOutput '      </P2>'];
    xmlOutput = [xmlOutput '    </Box>'];
    xmlOutput = [xmlOutput '  </Primitives>'];
    xmlOutput = [xmlOutput '</ProbeBox>'];

  elseif strncmp(   stlFile, 'voltageProbe', 10) == 1
    zlines = [zlines linspace(minZ, maxZ, 3)];  %added extra mesh lines for volatge probes to match their Z coords

    zcoord = minZ;  %current probe is in one level

    xmlOutput = [xmlOutput '<ProbeBox Name="' stlFileName '" Type="0" Weight="1">'];
    xmlOutput = [xmlOutput '  <Primitives>'];
    xmlOutput = [xmlOutput '    <Box Priority="999">'];
    xmlOutput = [xmlOutput '      <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str(zcoord) '">'];
    xmlOutput = [xmlOutput '      </P1>'];
    xmlOutput = [xmlOutput '      <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str(zcoord) '">'];
    xmlOutput = [xmlOutput '      </P2>'];
    xmlOutput = [xmlOutput '    </Box>'];
    xmlOutput = [xmlOutput '  </Primitives>'];
    xmlOutput = [xmlOutput '</ProbeBox>'];
  else
  endif

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End of properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput '    </Properties>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Write grid into file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlines = [xlines linspace(coords.gnd.minX, coords.gnd.maxX, 100)];
ylines = [ylines linspace(coords.gnd.minY, coords.gnd.maxY, 100)];
zlines = [zlines linspace(coords.gnd.minZ, coords.gnd.maxZ, 200)];

xlines = sort(unique(xlines));
ylines = sort(unique(ylines));
zlines = sort(unique(zlines));

xmlOutput = [xmlOutput '    <RectilinearGrid DeltaUnit="0.001" CoordSystem="0">' "\n"];
xmlOutput = [xmlOutput '      <XLines>' regexprep(num2str(xlines),'\s*','\,') '</XLines>'  "\n"];
xmlOutput = [xmlOutput '      <YLines>' regexprep(num2str(ylines),'\s*','\,') '</YLines>'  "\n"];
xmlOutput = [xmlOutput '      <ZLines>' regexprep(num2str(zlines),'\s*','\,') '</ZLines>'  "\n"];
xmlOutput = [xmlOutput '    </RectilinearGrid>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Write end of file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput '  </ContinuousStructure>' "\n"];
xmlOutput = [xmlOutput '</openEMS>' "\n"];  

display(xmlOutput);

outFile = fopen(outputFileName, 'w');
fwrite(outFile, xmlOutput);
fclose(outFile);
CSXGeomPlot(outputFileName);
