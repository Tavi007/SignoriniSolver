% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

f = @(x) 0;
solverPara.linearContact = 1;
problem = load_problem('Rechteck', 'Special', f, 'Special', solverPara);

mesh = load(strcat('Mesh/Files/Rechteck/level0.mat'));
mesh = set_boundary(mesh, problem);

%Testing u_h von Rademacher
u_h = [0.0, 0.0 ;
      -0.016461811645483267, -0.056769201225001634 ;
      -0.04817906538796307, -0.007674548329021448 ;
      -0.025110390964385932, 0.007624840542759266 ;
      0.0, 0.0 ;
      0.003715519534582007, -0.024069289925461836 ;
      -0.011817588461485257, 0.012782752611997588 ;
      -0.04040977983616535, 0.10719045932523973 ;
      0.0, 0.0 ;
      0.007059497566329764, -0.05874047623498932 ;
      0.017868419330236945, -0.05767782128974039 ;
      -0.011500823787913462, -0.005856837940453482 ];
ids = [4, 8, 12, 3, 7, 11, 2, 6, 10, 1, 5, 9];
u_h = u_h(ids,:);
u_h = [u_h(:,1); u_h(:,2)];
  
%compute error
L2_error = compute_L2_error(u_h, mesh);
grad_L2_error = compute_grad_L2_error(u_h, mesh);

%HHalf_errors = compute_HHalf_edge_error(lambda_h, mesh);

disp(strcat('L2:', num2str(L2_error), ' | should be: 0.11523'))
disp(strcat('gradL2:', num2str(grad_L2_error), ' | should be: 0.33358'))