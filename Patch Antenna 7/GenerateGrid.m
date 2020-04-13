addpath('C:\Users\H364387\Documents\Octave\STLread_for_Octave');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CONSTANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir('tmp');
outputFileName = './tmp/csxcad.xml';

epsilon_substrate = 3.66;
fmax = 8e9;
%mue_substrate = 1; %not used
fc = 8e9;
f0 = 4e9;
input1_resistance = 50;
NumberOfTimesteps = 1000e3;

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
    zlines = [zlines maxZ];
    
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
    xlines = [xlines linspace(minX, maxX, 20)];
    ylines = [ylines linspace(minY, maxY, 20)];
    zlines = [zlines linspace(minZ, maxZ, 3)];

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

    xlines = [xlines linspace(minX, maxX, 40)];
    ylines = [ylines linspace(minY, maxY, 40)];
    zlines = [zlines linspace(minZ, maxZ, 8)];

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

    xlines = [xlines linspace(minX, maxX, 10)];
    ylines = [ylines linspace(minY, maxY, 10)];
    zlines = [zlines linspace(minZ, maxZ, 3)];

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
  elseif strncmp(stlFile, 'excitation.stl', 4) == 1
    xlines = [xlines linspace(minX, maxX, 10)];
    ylines = [ylines linspace(minY, maxY, 4)];
    zlines = [zlines (maxZ + minZ)/2];
    
    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <LumpedElement Name="port_resist_' stlFileName '" Direction="2" Caps="1" R="' num2str(input1_resistance) '">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <Box Priority="999">' "\n"];
    xmlOutput = [xmlOutput '            <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str(maxZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P1>' "\n"];
    xmlOutput = [xmlOutput '            <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str(minZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P2>' "\n"];
    xmlOutput = [xmlOutput '          </Box>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </LumpedElement>' "\n"];
    xmlOutput = [xmlOutput '      <Excitation Name="port_excite_' stlFile '" Type="0" Excite="0,0,-1">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <Box Priority="999">' "\n"];
    xmlOutput = [xmlOutput '            <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str(maxZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P1>' "\n"];
    xmlOutput = [xmlOutput '            <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str(minZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P2>' "\n"];
    xmlOutput = [xmlOutput '          </Box>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </Excitation>' "\n"];
    xmlOutput = [xmlOutput '      <ProbeBox Name="port_ut1' '" Type="0" Weight="1">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <Box Priority="999">' "\n"];
    xmlOutput = [xmlOutput '            <P1 X="' num2str((minX+maxX)/2) '" Y="' num2str((minY+maxY)/2) '" Z="' num2str(maxZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P1>' "\n"];
    xmlOutput = [xmlOutput '            <P2 X="' num2str((minX+maxX)/2) '" Y="' num2str((minY+maxY)/2) '" Z="' num2str(minZ) '">' "\n"];
    xmlOutput = [xmlOutput '            </P2>' "\n"];
    xmlOutput = [xmlOutput '          </Box>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </ProbeBox>' "\n"];  
    xmlOutput = [xmlOutput '      <ProbeBox Name="port_it1' '" Type="1" Weight="-1" NormDir="2">' "\n"];
    xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    xmlOutput = [xmlOutput '          <Box Priority="999">' "\n"];
    xmlOutput = [xmlOutput '            <P1 X="' num2str(minX) '" Y="' num2str(minY) '" Z="' num2str((maxZ + minZ)/2) '">' "\n"];
    xmlOutput = [xmlOutput '            </P1>' "\n"];
    xmlOutput = [xmlOutput '            <P2 X="' num2str(maxX) '" Y="' num2str(maxY) '" Z="' num2str((maxZ + minZ)/2) '">' "\n"];
    xmlOutput = [xmlOutput '            </P2>' "\n"];
    xmlOutput = [xmlOutput '          </Box>' "\n"];
    xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    xmlOutput = [xmlOutput '      </ProbeBox>' "\n"];  
  else
  endif

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Write DUMP BOX AROUND ANTENNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%probe for patch
coords.Hplate.minX = coords.substrate.minX;
coords.Hplate.maxX = coords.substrate.maxX;
coords.Hplate.minY = coords.substrate.minY;
coords.Hplate.maxY = coords.substrate.maxY;
coords.Hplate.minZ = coords.substrate.maxZ + 1.0;   %plate is one dimensional on same level, no box
coords.Hplate.maxZ = coords.substrate.maxZ + 1.0;

%electric and magnetic box
coords.Hbox.minX = (coords.substrate.minX + coords.air.minX) / 2;
coords.Hbox.maxX = (coords.substrate.maxX + coords.air.maxX) / 2;
coords.Hbox.minY = (coords.substrate.minY + coords.air.minY) / 2;
coords.Hbox.maxY = (coords.substrate.maxY + coords.air.maxY) / 2;
coords.Hbox.minZ = (coords.substrate.minZ + coords.air.minZ) / 2;
coords.Hbox.maxZ = (coords.substrate.maxZ + coords.air.maxZ) / 2;

coords.Ebox.minX = (coords.substrate.minX + coords.air.minX) / 2;
coords.Ebox.maxX = (coords.substrate.maxX + coords.air.maxX) / 2;
coords.Ebox.minY = (coords.substrate.minY + coords.air.minY) / 2;
coords.Ebox.maxY = (coords.substrate.maxY + coords.air.maxY) / 2;
coords.Ebox.minZ = (coords.substrate.minZ + coords.air.minZ) / 2;
coords.Ebox.maxZ = (coords.substrate.maxZ + coords.air.maxZ) / 2;

%xml string for openEMS
xmlOutput = [xmlOutput '<DumpBox Name="Ht_" DumpMode="2" DumpType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hplate.minX) '" Y="' num2str(coords.Hplate.minY) '" Z="' num2str(coords.Hplate.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hplate.maxX) '" Y="' num2str(coords.Hplate.maxY) '" Z="' num2str(coords.Hplate.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_xn" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Ebox.minX) '" Y="' num2str(coords.Ebox.minY) '" Z="' num2str(coords.Ebox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Ebox.minX) '" Y="' num2str(coords.Ebox.maxY) '" Z="' num2str(coords.Ebox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_xn" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_xp" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_xp" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_yn" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_yn" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_yp" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_yp" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_zn" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_zn" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.minZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_E_zp" DumpMode="1" DumpType="0" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

xmlOutput = [xmlOutput '<DumpBox Name="nf2ff_H_zp" DumpMode="1" DumpType="1" FileType="1">' "\n"];
xmlOutput = [xmlOutput '  <Primitives>' "\n"];
xmlOutput = [xmlOutput '    <Box Priority="0">' "\n"];
xmlOutput = [xmlOutput '      <P1 X="' num2str(coords.Hbox.minX) '" Y="' num2str(coords.Hbox.minY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P1>' "\n"];
xmlOutput = [xmlOutput '      <P2 X="' num2str(coords.Hbox.maxX) '" Y="' num2str(coords.Hbox.maxY) '" Z="' num2str(coords.Hbox.maxZ) '">' "\n"];
xmlOutput = [xmlOutput '      </P2>' "\n"];
xmlOutput = [xmlOutput '    </Box>' "\n"];
xmlOutput = [xmlOutput '  </Primitives>' "\n"];
xmlOutput = [xmlOutput '</DumpBox>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End of properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput '    </Properties>' "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Write grid into file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
