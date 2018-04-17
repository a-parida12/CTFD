clc 
clear
N = 100;
L = 20;
D = 0.5;
Vx = 2;
%%
syms  phi(x,t) a(m) a(m,t) PHI(x,t); 
phi(x,t)= piecewise(0<x<=1,x, 1<x<=2, 2-x, 2<x<L,0);
a(m)=(2/L) *int(phi(x,t)*sin(m*pi*x/L),x,0,L);
a(m,t) = exp(-D*((m*pi/L)^2)*t)*a(m);
PHI(x,t) = sum(subs(a(m,t)*sin(m*pi*(x-Vx*t)/L),m,1:N));
%%
t=1;
figure
plot(-L:L,PHI(-L:L,t))
title('Function phi(x,t) with L=20 and N=100')
xlabel('space')
ylabel('phi(x,t)')
%%
fig = figure;
axis tight manual;
filename = 'ConvectionDiffusion.gif';
for t=0:.1:5;
    x = -L:L;
    y = PHI(-L:L,t);
    plot(x,y)
    xlabel('space')
    ylabel('phi(x,t)')
    axis([-L L -1 1]) 
    drawnow
    %%
     F = getframe(fig); 
      im = frame2im(F); 
      [imind,cm] = rgb2ind(im,256); 
      if t == 0 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
end
