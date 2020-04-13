Sim_Path = './tmp';
Sim_CSX = 'csxcad.xml';

filePath = [Sim_Path '/'];

openEMS_opts = '';
f0 = 0e9;
fc = 4e9;

%CSXGeomPlot([Sim_Path '/' Sim_CSX]);
%RunOpenEMS(Sim_Path, Sim_CSX);

%%
%freq = linspace(0,2*f0,201);
%LuboJ.
freq = linspace(0,5e9,1001);

port{1}.uf = ReadUI({'voltageProbe_u1_A', 'et'}, Sim_Path, freq ); % time domain/freq domain voltage
port{2}.uf = ReadUI({'voltageProbe_u1_B', 'et'}, Sim_Path, freq ); % time domain/freq domain voltage
port = calcPort(port, Sim_Path, freq); 

%U = ReadUI( {'voltageProbe_u1_A','et'}, Sim_Path, freq ); % time domain/freq domain voltage
%I = ReadUI( 'currentProbe_i1_A', Sim_Path, freq ); % time domain/freq domain current (half time step is corrected)


%% plot s-parameter
figure
s11 = port{1}.uf.ref./port{1}.uf.inc;
s21 = port{2}.uf.inc./port{1}.uf.inc;
plot(freq,20*log10(abs(s11)),'Linewidth',2);
hold on
grid on
plot(freq,20*log10(abs(s21)),'r--','Linewidth',2);
xlim([freq(1) freq(end)]);
xlabel('frequency (Hz)')
ylabel('s-para (dB)');

%% plot line-impedance comparison
figure()
ZL_a = ones(size(freq))*Z0/2/pi/sqrt(epsR)*log(coax_rad_ai/coax_rad_i); %analytic line-impedance of a coax
ZL = port{2}.uf.tot./port{2}.if.tot;
plot(freq,real(port{1}.ZL),'Linewidth',2);
xlim([freq(1) freq(end)]);
xlabel('frequency (Hz)')
ylabel('line-impedance (\Omega)');
grid on;
hold on;
plot(freq,imag(port{1}.ZL),'r--','Linewidth',2);
plot(freq,ZL_a,'g-.','Linewidth',2);
legend('\Re\{ZL\}','\Im\{ZL\}','ZL-analytic','Location','Best'); 