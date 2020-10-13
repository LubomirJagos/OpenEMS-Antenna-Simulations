addpath('C:\Users\H364387\Documents\Octave\STLread_for_Octave');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CONSTANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir('tmp');
outputFileName = './tmp/model.m';

epsilon_substrate = 3.66;
fmax = 8e9;
%mue_substrate = 1; %not used
f0 = 0e9;
fc = 4e9;
length = 1000;          %length of the waveguide
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
  "voltageProbe_u2_C.stl",
  "__makeGrid",              % <--- LuboJ this is mz command to create grid before add excitations
  "excitationCoax.stl"
];

xlines = [];
ylines = [];
zlines = [];
xmlOutput = "";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate start of file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput 'addpath(''C:/Users/H364387/Downloads/openEMS/matlab'');' "\n"];
xmlOutput = [xmlOutput 'close all' "\n"];
xmlOutput = [xmlOutput 'clear' "\n"];
xmlOutput = [xmlOutput 'clc' "\n"];
xmlOutput = [xmlOutput "\n"];
xmlOutput = [xmlOutput 'Sim_Path = ''.'';' "\n"];
xmlOutput = [xmlOutput 'Sim_CSX = ''csxcad2.xml'';' "\n"];
xmlOutput = [xmlOutput "\n"];
xmlOutput = [xmlOutput 'fc = ' num2str(fc) ';' "\n"];
xmlOutput = [xmlOutput 'f0 = ' num2str(f0) ';' "\n"];
xmlOutput = [xmlOutput 'fc = ' num2str(fc) ';' "\n"];
xmlOutput = [xmlOutput 'length = ' num2str(length) ';           %coax length' "\n"];
xmlOutput = [xmlOutput 'numTS = ' num2str(NumberOfTimesteps) ';           %number of timesteps' "\n"];
xmlOutput = [xmlOutput 'unit = 1e-3;            %drawing unit used' "\n"];
xmlOutput = [xmlOutput 'mesh_res = [5 5 5];     %desired mesh resistance' "\n"];
xmlOutput = [xmlOutput 'physical_constants;' "\n"];
xmlOutput = [xmlOutput "\n"];
xmlOutput = [xmlOutput 'FDTD = InitFDTD(numTS,1e-5);' "\n"];
xmlOutput = [xmlOutput 'FDTD = SetGaussExcite(FDTD,f0,f0);' "\n"];
xmlOutput = [xmlOutput 'BC = {''PEC'',''PEC'',''PEC'',''PEC'',''MUR'',''MUR''};' "\n"];
xmlOutput = [xmlOutput 'FDTD = SetBoundaryCond(FDTD,BC);' "\n"];
xmlOutput = [xmlOutput 'CSX = InitCSX();' "\n"];
xmlOutput = [xmlOutput "\n"];
xmlOutput = [xmlOutput 'CSX = AddMetal(CSX,''copper'');' "\n"];
xmlOutput = [xmlOutput "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Go through iles and generate grid lines positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

portNumber = 1;   %after add port this number will increase, port index

for k = 1:size(simFiles)
  stlFile = simFiles(k, :);
  stlFileName = strtrim(substr(strtrim(stlFile), 1, size(strtrim(stlFile))(2) - 4));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  Show info for STL files
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (findstr(stlFile, '.stl') ~= -1)
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
  endif
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  Go through all STL files and do stuff which you need according to files
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if strncmp(stlFile, 'antenna.stl', 4) == 1
    xmlOutput = [xmlOutput 'CSX = ImportSTL(CSX, ''copper'',10, [''' stlFile '''],''Transform'',{''Scale'', 1});' "\n"];

  elseif strncmp(stlFile, 'gnd.stl', 4) == 1
    coords.gnd.minX = minX;
    coords.gnd.maxX = maxX;
    coords.gnd.minY = minY;
    coords.gnd.maxY = maxY;
    coords.gnd.minZ = minZ;
    coords.gnd.maxZ = maxZ;

    %add stl object into xml file into openems model
    xmlOutput = [xmlOutput 'CSX = ImportSTL(CSX, ''copper'',10, [''' stlFile '''],''Transform'',{''Scale'', 1});' "\n"];
  elseif strncmp(stlFile, 'air.stl', 4) == 1    
    coords.air.minX = minX;
    coords.air.maxX = maxX;
    coords.air.minY = minY;
    coords.air.maxY = maxY;
    coords.air.minZ = minZ;
    coords.air.maxZ = maxZ;

    %add stl object into xml file into openems model
    xmlOutput = ['CSX = ImportSTL(CSX, ''air'',10, [''' stlFile '''],''Transform'',{''Scale'', 1});' "\n"];
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

      xmlOutput = [xmlOutput 'coax_rad_i = ' num2str(minR) ';' "\n"];
      xmlOutput = [xmlOutput 'coax_rad_ai = ' num2str(maxR) ';' "\n"];
      xmlOutput = [xmlOutput 'coax_rad_aa = ' num2str(shellWidth) ';' "\n"];
      
      if (abs(minZ - maxZ) ~= 0)        
        if (portNumber == 1)
          xmlOutput = [xmlOutput 'start = [0,0,0];' "\n"];
          xmlOutput = [xmlOutput 'stop  = [0,0,length/2];' "\n"];
          xmlOutput = [xmlOutput '[CSX,port{' num2str(portNumber) '}] = AddCoaxialPort( CSX, 10, ' num2str(portNumber) ', ''copper'', '''', start, stop, ''z'', coax_rad_i, coax_rad_ai, coax_rad_aa, ''ExciteAmp'', 1,''FeedShift'', 10*mesh_res(1) );' "\n"];
        else
          xmlOutput = [xmlOutput 'start = [0,0,length/2];' "\n"];
          xmlOutput = [xmlOutput 'stop  = [0,0,length];' "\n"];
          xmlOutput = [xmlOutput '[CSX,port{' num2str(portNumber) '}] = AddCoaxialPort( CSX, 10, ' num2str(portNumber) ', ''copper'', '''', start, stop, ''z'', coax_rad_i, coax_rad_ai, coax_rad_aa);' "\n"];
        endif
      else
        %here will be generate rectangle box with excitation if there is non zero height
      endif
    
  elseif strncmp(stlFile, 'currentProbe', 10) == 1
    zlines = [zlines linspace(minZ, maxZ, 3)];  %added extra mesh lines for current probes to match their Z coords
    zcoord = minZ;  %current probe is in one level
  
  elseif strncmp(stlFile, 'voltageProbe', 10) == 1
    zlines = [zlines linspace(minZ, maxZ, 3)];  %added extra mesh lines for volatge probes to match their Z coords
    zcoord = minZ;  %current probe is in one level
  
  elseif strncmp(stlFile, '__makeGrid', 10) == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Write grid into file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlines = [xlines linspace(coords.gnd.minX, coords.gnd.maxX, 100)];
    ylines = [ylines linspace(coords.gnd.minY, coords.gnd.maxY, 100)];
    zlines = [zlines linspace(coords.gnd.minZ, coords.gnd.maxZ, 200)];

    xlines = sort(unique(xlines));
    ylines = sort(unique(ylines));
    zlines = sort(unique(zlines));

    xlinesStr = '';
    for k = 1:size(xlines)(2)
      xlinesStr = [xlinesStr num2str(xlines(k)) ','];
    endfor
    xmlOutput = [xmlOutput 'mesh.x = [' xlinesStr '];' "\n"];
    ylinesStr = '';
    for k = 1:size(ylines)(2)
      ylinesStr = [ylinesStr num2str(ylines(k)) ','];
    endfor
    xmlOutput = [xmlOutput 'mesh.y = [' ylinesStr '];' "\n"];
    zlinesStr = '';
    for k = 1:size(zlines)(2)
      zlinesStr = [zlinesStr num2str(zlines(k)) ','];
    endfor
    xmlOutput = [xmlOutput 'mesh.z = [' zlinesStr '];' "\n"];
    xmlOutput = [xmlOutput 'CSX = DefineRectGrid(CSX, unit, mesh);' "\n"];
  else
  endif

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Dump boxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlOutput = [xmlOutput '%% define dump boxes... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' "\n"];
xmlOutput = [xmlOutput 'CSX = AddDump(CSX,''Et_'',''DumpMode'',2);' "\n"];
xmlOutput = [xmlOutput 'start = [mesh.x(1) , 0 , mesh.z(1)];' "\n"];
xmlOutput = [xmlOutput 'stop = [mesh.x(end) , 0 , mesh.z(end)];' "\n"];
xmlOutput = [xmlOutput 'CSX = AddBox(CSX,''Et_'',0 , start,stop);' "\n"];
xmlOutput = [xmlOutput 'CSX = AddDump(CSX,''Ht_'',''DumpType'',1,''DumpMode'',2);' "\n"];
xmlOutput = [xmlOutput 'CSX = AddBox(CSX,''Ht_'',0,start,stop);' "\n"];
xmlOutput = [xmlOutput "\n"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Write end of file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xmlOutput = [xmlOutput 'WriteOpenEMS([Sim_Path ''/'' Sim_CSX],FDTD,CSX);' "\n"];
xmlOutput = [xmlOutput 'CSXGeomPlot([Sim_Path ''/'' Sim_CSX]);' "\n"];


display(xmlOutput);

outFile = fopen(outputFileName, 'w');
fwrite(outFile, xmlOutput);
fclose(outFile);
