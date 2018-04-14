clc
clear
close all
N=100;
L=20;

%% Stage 1: Symbolic Toolbox
syms a(m) phi(x) tildaphi(x);

phi(x)=piecewise(0<x<=1,x, 1<x<=2, 2-x, 2<x<L,0);
a(m)=(2/L) *int(phi(x)*sin(m*pi*x/L),x,0,L);

tildaphi(x)=sum(subs(a(m)*sin(m*pi*x/L),m,1:N));

%%  Stage 2: Ploting tildaphi(x)
figure('Name','tildaphi(x)')

plot(-L:L,tildaphi(-L:L))

xlabel('space')
ylabel('phi(x)')
title(strcat('phi(x) with L= ',num2str(L),' and N= ',num2str(N)))
%% Stage 3: Making Movie of Convection

v_x=1;

h = figure('Name','tildaphi(x-v*t)');
axis tight manual
filename = 'Convection.gif';
for t = 1:1:19
    % Draw plot for y = x.^n
    x = -L:L;
    y = tildaphi([-L:L]-v_x*(t-1) );
    plot(x,y) 
    drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,8); 
      % Write to the GIF File 
      if t == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append','Delaytime',0); 
      end 
  end