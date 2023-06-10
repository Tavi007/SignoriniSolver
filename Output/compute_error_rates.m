% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

level_min = 0;
level_max = 5;
rate_bool = true;

L2_errors = zeros(level_max+1,2);
L2_errors_rate = zeros(level_max+1,2);
HHalf_errors = zeros(level_max+1,2);
HHalf_errors_rate = zeros(level_max+1,2);
grad_L2_errors = zeros(level_max+1,2);
H1_errors_rate = zeros(level_max+1,2);
Mixed_errors_rate = zeros(level_max+1,2);

filepathInput_base = strcat('Output/RechteckDomain/SpecialObstacle/SpecialForce/Linear elastisch/'); 
f = @(x) 0;
solverPara.linearContact = 1;
problem = load_problem('Rechteck', 'Special', f, 'Special', solverPara);

filename_log = strcat('Output/RechteckDomain/SpecialObstacle/SpecialForce/ErrorLog_test.txt');
delete(filename_log)
diary(filename_log)
%load solutions
for lvl = level_min:level_max
  level = num2str(lvl)
  %loading data
  u_linC = load(strcat(filepathInput_base,'linC/Saves/u',level,'.mat')).u_sol;
  lambda_linC = load(strcat(filepathInput_base,'linC/Saves/lmd',level,'.mat')).lambda_sol;
  u_genC = load(strcat(filepathInput_base,'genC/Saves/u',level,'.mat')).u_sol;
  lambda_genC = load(strcat(filepathInput_base,'genC/Saves/lmd',level,'.mat')).lambda_sol;
  mesh = load(strcat('Mesh/Files/Rechteck/level',level,'.mat'));
  mesh = set_boundary(mesh, problem);
  
  %plot_lambda(lambda_linC, mesh, lvl+1)
  
  %compute error
  L2_errors(lvl+1, 1) = compute_L2_error(u_linC, mesh);
  L2_errors(lvl+1, 2) = compute_L2_error(u_genC, mesh);
  grad_L2_errors(lvl+1, 1) = compute_grad_L2_error(u_linC, mesh);
  grad_L2_errors(lvl+1, 2) = compute_grad_L2_error(u_genC, mesh);
  HHalf_errors(lvl+1, 1) = compute_HHalf_edge_error(lambda_linC, mesh);
  HHalf_errors(lvl+1, 2) = compute_HHalf_edge_error(lambda_genC, mesh);

end

H1_errors = sqrt(L2_errors.^2 + grad_L2_errors.^2);
Mixed_errors = H1_errors + HHalf_errors;

if rate_bool
  for i = level_min+1:level_max
    L2_errors_rate(i+1,1) = log2(L2_errors(i,1)/L2_errors(i+1,1));
    L2_errors_rate(i+1,2) = log2(L2_errors(i,2)/L2_errors(i+1,2));
    H1_errors_rate(i+1,1) = log2(H1_errors(i,1)/H1_errors(i+1,1));
    H1_errors_rate(i+1,2) = log2(H1_errors(i,2)/H1_errors(i+1,2));
    HHalf_errors_rate(i+1,1) = log2(HHalf_errors(i,1)/HHalf_errors(i+1,1));
    HHalf_errors_rate(i+1,2) = log2(HHalf_errors(i,2)/HHalf_errors(i+1,2));
    Mixed_errors_rate(i+1,1) = log2(Mixed_errors(i,1)/Mixed_errors(i+1,1));
    Mixed_errors_rate(i+1,2) = log2(Mixed_errors(i,2)/Mixed_errors(i+1,2));
  end
end
diary off;
filename_log = strcat('Output/RechteckDomain/SpecialObstacle/SpecialForce/ErrorLog.txt');
delete(filename_log)
diary(filename_log)

disp('L2:')
disp(L2_errors)
disp('H1:')
disp(H1_errors)
disp('L2_Lambda:')
disp(HHalf_errors)
disp('Mixed:')
disp(Mixed_errors)


if rate_bool
  disp('L2_rate:')
  disp(L2_errors_rate)
  disp('H1_rate:')
  disp(H1_errors_rate)
  disp('L2_Lambda:')
  disp(HHalf_errors_rate)
  disp('Mixed_rate:')
  disp(Mixed_errors_rate)
end
diary off