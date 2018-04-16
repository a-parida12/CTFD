clc 
clear
N = 100;
L = 20;
D = 1;
%%
syms  phi(x,t) a(m) a(t) PHI(x,t); 
phi(x,t)= piecewise(0<x<=1,x, 1<x<=2, 2-x, 2<x<L,0);
a(m)=(2/L) *int(phi(x,t)*sin(m*pi*x/L),x,0,L);
a(t) = int(exp(-D*((m*pi/L)^2)*t)*a(m),x,0,L);
PHI(x,t) = sum(subs(a(t)*sin(m*pi*x/L),m,1:N));
%%
figure
plot(-L:L,PHI(-L:L,10:10))
title('Function phi(x,t) with L=20 and N=100')
xlabel('space')
ylabel('phi(x,t)')
%%
Vx = 1;
fig = figure;
axis tight manual;
filename = 'movie of diffusion.gif';
for t=0:1:20
    x = -L:L;
    y = PHI((-L:L)-(Vx*t));
    plot(x,y)
    xlabel('space')
    ylabel('phi(x,t)')
    drawnow
    %%
     F = getframe(fig); 
      im = frame2im(F); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if t == 0 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
end
