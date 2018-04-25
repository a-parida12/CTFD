clear all
clc

% Numerical code to solve the 2D steady heat equation by Finite Differences
% Second order accurate in Space
%
%

% Gemetrical Parameters

l = 1;                      % Length of the domain in x 
h = 2;                      % Length of the domain in y
dimX = 5;                  % Number of nodes in x
dimY = 5;                  % Number of nodes in y 
dx=l/(dimX-1);
dy=h/(dimY-1);
% Defining Boundary conditions

% Type
boundary.south = 'Neumann';
boundary.north = 'Robin';
boundary.east  = 'Robin';
boundary.west  = 'Dirichlet';

% Value for Dirichlet BC
TNorth = 10;
TSouth= 50;
TWest= 50;
TEast=10;

% Values of Neumann BC
beta = 0;                   % Heat flux
% Values of Robin BC
alpha = 1;                  % Convective heat transfer coefficient
Tinf = 100;                  % Temperature of the surrounding fluid


% Thermal conductivity Coefficient

heat_conduc='homogeneous';   %1) homgeneous, 2) non homogeneous
Kval = 1;


% Region with different K

KnH = 10;                   % Thermal conductivity for the particular region

yk = [0.5 4.8];
xk = [1 1.5];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------------------------------
% Define Temperature T matrix (Intial values with zero for example)

T=zeros(dimX,dimY);
T(:,1)=TEast;
T(:,dimY)=TWest;
T(1,:)=TNorth;
T(dimX,:)=TSouth;



%------------------------------------------------------
% Create mesh (2D MESH). (Matrix X and Matrix Y)
[X,Y] = meshgrid(0:dx:l,0:dy:h);



%----------------------------------------------------------------------
% Define the Heat conductivity coefficient values


switch heat_conduc
    
    case 'homogeneous'
        lambda_x= Kval;
        lambda_y= Kval;
        
        
    case 'non homogeneous'
        lambda_x= Kval*.8;
        lambda_y= Kval*1.2;

end

%-----------------------------------------------------------------------
% Defining the Source

%-----------------------------------------------------------------------
% Defining Boundary conditions
f=zeros([(dimX-2) *(dimY-2),1]);
f(1:dimX-2)=f(1:dimX-2)+(TEast*lambda_x)/dy^2;
f(end-(dimX-2)+1:end)=f(end-(dimX-2)+1:end)+(TWest*lambda_x)/dy^2;

f(1:dimX-2:end)=f(1:dimX-2:end)+(TNorth*lambda_y)/dx^2;
f(dimX-2:dimX-2:end)=f(dimX-2:dimX-2:end)+(TSouth*lambda_y)/dx^2;

%------------------------------------------------------------------------
% Constructing Matrix A;

A=zeros((dimX-2) *(dimY-2));

for i=1:(dimX-2) *(dimY-2)
    A(i,i)=-2*(lambda_x/dx^2+lambda_y/dy^2);
    
end

for i=1:(dimX-2)-1
    for j=1:(dimY-2)
        A(i+(j-1)*(dimX-2),i+(j-1)*(dimX-2)+1)=lambda_x/dx^2;
        A(i+(j-1)*(dimX-2)+1,i+(j-1)*(dimX-2))=lambda_x/dx^2;
    end
end

for i=1:(dimX-2)
    for j=1:(dimY-2)-1
        A(i+(j-1)*(dimX-2),i+j*(dimX-2))=lambda_y/dy^2;
        A(i+j*(dimX-2),i+(j-1)*(dimX-2))=lambda_y/dy^2;
    end
end

%------------------------------------------------------------------------      
% Solving the linear system (use '\' operator)
        
u=-A\f;
    
T(2:dimX-1,2:dimY-1)=reshape(u,[(dimX-2),(dimY-2)]);
%------------------------------------------------------------------------
% Ploting Results

% Do a surface plot
figure(1)

surf(X, Y, T)
colorbar
title(strcat('Steady State Temperature for l=',num2str(l),' h= ',num2str(h), ' with k=',num2str(Kval)))
xlabel('dimX')
ylabel('dimY')
zlabel('Temperature')
saveas(gcf,'SteadySurf.png')
% Do a contour plot

figure(2) 

contour(X,Y,T,'ShowText','on')
title(strcat('Steady State Temperature for l=',num2str(l),' h= ',num2str(h), ' with k=',num2str(Kval)))
xlabel('dimX')
ylabel('dimY')
saveas(gcf,'SteadyContour.png')
% Do a color plot

figure(3)

surf(X, Y, T,'EdgeColor', 'None', 'facecolor', 'interp');
view(2)
title(strcat('Steady State Temperature for l=',num2str(l),' h= ',num2str(h), ' with k=',num2str(Kval)))
xlabel('dimX')
ylabel('dimY')
saveas(gcf,'SteadyColor.png')


