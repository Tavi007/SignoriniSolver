% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('../MathTools');

%For loading data
obstacleName = 'Spitze';           %'Parabel', 'Spitze', 'Hut'
forceName = 'Constant20';           %'Constant10', 'Constant15', 'Constant20'
materialName = 'Neo Hooke';  %'Linear elastisch', 'Neo Hooke', 'St.Venant'


for i = 0:0
  level = num2str(i);
  %loading data
  filepathInput_linC = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/',forceName,'Force/',materialName,'/linC/Saves/');
  u_linC = load(strcat(filepathInput_linC,'u',level,'.mat')).u_sol;
  lambda_linC = load(strcat(filepathInput_linC,'lmd',level,'.mat')).lambda_sol;
  filepathInput_genC = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/',forceName,'Force/',materialName,'/genC/Saves/');
  u_genC = load(strcat(filepathInput_genC,'u',level,'.mat')).u_sol;
  lambda_genC = load(strcat(filepathInput_genC,'lmd',level,'.mat')).lambda_sol;

  disp('-----------')
  disp(strcat('level =', level))
  norm_u = max(abs(u_linC-u_genC));
  norm_u
  norm_lambda = max(abs(lambda_linC-lambda_genC));
  norm_lambda
end