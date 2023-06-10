% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

level = '1';
mesh = load(strcat('Mesh/Files/Rechteck/level',level,'.mat'));
noElem = mesh.noElem;

[u1, u2] = get_special_solution();
[du1_dx_ana, du1_dy_ana, du2_dx_ana, du2_dy_ana] = get_special_gradSolution();
gradU_ana = @(x) [du1_dx_ana(x), du1_dy_ana(x), du2_dx_ana(x), du2_dy_ana(x)];

h = 1e-3;
du1_dx_num = @(x) (u1(x+[h;0]) - u1(x))/h;
du1_dy_num = @(x) (u1(x+[0;h]) - u1(x))/h;
du2_dx_num = @(x) (u2(x+[h;0]) - u2(x))/h;
du2_dy_num = @(x) (u2(x+[0;h]) - u2(x))/h;
gradU_num = @(x) [du1_dx_num(x), du1_dy_num(x), du2_dx_num(x), du2_dy_num(x)];

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
  gradU_ana_hat = @(x_hat) gradU_ana(trafo_from_ref_2d(x_hat,element,mesh));
  gradU_num_hat = @(x_hat) gradU_num(trafo_from_ref_2d(x_hat,element,mesh));
  gradU_err = @(x_hat) gradU_ana_hat(x_hat) - gradU_num_hat(x_hat);
  
  integrand = @(x_hat) gradU_err(x_hat).^2 * TrafoDet;
  error_el = quadrature2d(integrand,4); %quadOrder = 4
  
  error = error + error_el; 
end

disp(strcat('Error von du1_dx:_', num2str(error(1))))
disp(strcat('Error von du1_dy:_', num2str(error(2))))
disp(strcat('Error von du2_dx:_', num2str(error(3))))
disp(strcat('Error von du2_dy:_', num2str(error(4))))


