% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

level = '1';
mesh = load(strcat('Mesh/Files/Rechteck/level',level,'.mat'));
noElem = mesh.noElem;

[du1_dx, du1_dy, du2_dx, du2_dy] = get_special_gradSolution();
[dxxU1_ana, dxyU1_ana, dyyU1_ana, dxxU2_ana, dxyU2_ana, dyyU2_ana] = get_special_gradGradSolution();
gradGradU_ana = @(x) [dxxU1_ana(x), dxyU1_ana(x), dyyU1_ana(x), dxxU2_ana(x), dxyU2_ana(x), dyyU2_ana(x)];

h = 1e-6;
dxxU1_num = @(x) (du1_dx(x+[h;0]) - du1_dx(x))/h;
dxyU1_num = @(x) (du1_dx(x+[0;h]) - du1_dx(x))/h;
dyyU1_num = @(x) (du1_dy(x+[0;h]) - du1_dy(x))/h;

dxxU2_num = @(x) (du2_dx(x+[h;0]) - du2_dx(x))/h;
dxyU2_num = @(x) (du2_dx(x+[0;h]) - du2_dx(x))/h;
dyyU2_num = @(x) (du2_dy(x+[0;h]) - du2_dy(x))/h;
gradGradU_num = @(x) [dxxU1_num(x), dxyU1_num(x), dyyU1_num(x), dxxU2_num(x), dxyU2_num(x), dyyU2_num(x)];

%Assembly error 
error = 0;
for e = 1:noElem %loop over elements
  error_el = 0;
  
  %Define Trafo
  element = mesh.elements(e,:);
  a1 = mesh.vertices(element(1),:)';
  a2 = mesh.vertices(element(2),:)';
  a3 = mesh.vertices(element(3),:)';
  DTrafo = [[a2-a1, a3-a1], [0;0];
  [0,0]         , 1]; % x = DTrafo*x_hat + d
  DTrafo_inv_T = (inv(DTrafo))';
  TrafoDet = det(DTrafo);
  
  %analytical solution. x-Value will be transformed to the real coordinates first.
  gradGradU_ana_hat = @(x_hat) gradGradU_ana(trafo_from_ref_2d(x_hat,element,mesh));
  gradGradU_num_hat = @(x_hat) gradGradU_num(trafo_from_ref_2d(x_hat,element,mesh));
  gradGradU_err = @(x_hat) gradGradU_ana_hat(x_hat) - gradGradU_num_hat(x_hat);
  
  integrand = @(x_hat) gradGradU_err(x_hat).^2 * TrafoDet;
  error_el = quadrature2d(integrand,4); %quadOrder = 4
  
  error = error + error_el; 
end

disp(strcat('Error von du1_dx:_', num2str(error(1))))
disp(strcat('Error von du1_dy:_', num2str(error(2))))
disp(strcat('Error von du2_dx:_', num2str(error(3))))
disp(strcat('Error von du2_dy:_', num2str(error(4))))
disp(strcat('Error von du2_dy:_', num2str(error(5))))
disp(strcat('Error von du2_dy:_', num2str(error(6))))


