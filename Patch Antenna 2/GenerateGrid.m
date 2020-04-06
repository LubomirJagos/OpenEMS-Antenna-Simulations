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
    xlines = [xlines linspace(0, minX, 10) linspace(minX, maxX, 100)];
    ylines = [ylines linspace(0, minY, 10) linspace(minY, maxY, 100)];
    zlines = [minZ zlines];

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
    xlines = [xlines linspace(max(xlines), maxX, 10)];
    ylines = [linspace(minY, min(ylines), 10) ylines];
    ylines = [ylines linspace(max(ylines), maxY)];
    zlines = [zlines linspace(minZ, maxZ, 10)];

    %add stl object into xml file into openems model
    %xmlOutput = [xmlOutput '      <Material Name="' stlFileName '">' "\n"];
    %xmlOutput = [xmlOutput '        <Property Epsilon="1" Mue="1" kappa="0">' "\n"];
    %xmlOutput = [xmlOutput '        </Property>' "\n"];
    %xmlOutput = [xmlOutput '        <Primitives>' "\n"];
    %xmlOutput = [xmlOutput '          <PolyhedronReader Priority="10" FileName="' pwd() '\' stlFile '" FileType="STL">' "\n"];
    %xmlOutput = [xmlOutput '            <Transformation>' "\n"];
    %xmlOutput = [xmlOutput '              <Scale Argument="1">' "\n"];
    %xmlOutput = [xmlOutput '              </Scale>' "\n"];
    %xmlOutput = [xmlOutput '            </Transformation>' "\n"];
    %xmlOutput = [xmlOutput '          </PolyhedronReader>' "\n"];
    %xmlOutput = [xmlOutput '        </Primitives>' "\n"];
    %xmlOutput = [xmlOutput '      </Material>' "\n"];
  elseif strncmp(stlFile, 'substrate.stl', 4) == 1
    zlines = [zlines linspace(minZ, maxZ, 10)];

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
    xlines = [xlines linspace(minX, maxX, 5)];
    ylines = [ylines linspace(minY, maxY, 4)];
    zlines = [zlines (maxZ + minZ)/2];
    
    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput '      <LumpedElement Name="port_resist_' stlFileName '" Direction="2" Caps="1" R="50">' "\n"];
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
%  Write grid into file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlines = sort(unique(xlines));
ylines = sort(unique(ylines));
zlines = sort(unique(zlines));

xmlOutput = [xmlOutput '    </Properties>' "\n"];
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

outFile = fopen('csxcad.xml', 'w');
fwrite(outFile, xmlOutput);
fclose(outFile);
