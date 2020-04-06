
CSXGeomPlot( [Sim_Path '/' Sim_CSX] );


 % include the line above to launch csxcad omitt it to avoid launching CSXCad
 RunOpenEMS( Sim_Path, Sim_CSX );


 %% post-processing
 close all
 f = linspace( 1e6, 2e9, 1601 );
 port = calcPort( port, Sim_Path, f, 'RefImpedance', 50);

 s11 = port{1}.uf.ref./ port{1}.uf.inc;
 s21 = port{2}.uf.ref./ port{1}.uf.inc;

 plot(f/1e9,20*log10(abs(s11)),'k-','LineWidth',2);
 hold on;
 grid on;
 plot(f/1e9,20*log10(abs(s21)),'r--','LineWidth',2);
 legend('S_{11}','S_{21}');
 ylabel('S-Parameter (dB)','FontSize',12);
 xlabel('frequency (GHz) \rightarrow','FontSize',12);
 ylim([-60 2]);
 print ('hairpinfilter_simulation.png', '-dpng');


