% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('../MathTools');

% Data
materialName = 'Linear elastisch';  %'Linear elastisch', 'Neo Hooke', 'St.Venant'
obstacleName = 'Hut';           %'Parabel', 'Spitze', 'Hut'
forceName = '20';           %'Constant10', 'Constant15', 'Constant20'
contactName = 'genC';               %'linC', 'genC'
VergleichKontakt = false;

for i = 6:6
level = num2str(i);


if VergleichKontakt
  filepathInput = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/Constant',forceName,'Force/',materialName,'/linC/Saves/');
  forceConv_lin = load(strcat(filepathInput,'ForceConv',level,'.mat')).equilibriumConvergence;
  contactConv_lin = load(strcat(filepathInput,'ContactConv',level,'.mat')).contactConvergence;
  
  filepathInput = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/Constant',forceName,'Force/',materialName,'/genC/Saves/');
  forceConv_gen = load(strcat(filepathInput,'ForceConv',level,'.mat')).equilibriumConvergence;
  contactConv_gen = load(strcat(filepathInput,'ContactConv',level,'.mat')).contactConvergence;
  
  dataList = {forceConv_lin, contactConv_lin, forceConv_gen, contactConv_gen};
  colorList = {'blue', 'red', 'cyan', 'magenta'};
  
  if strcmp(materialName, 'Linear elastisch')
    filename = strcat('LinE_', obstacleName, '_F', forceName, '_Lvl', level);
  elseif strcmp(materialName, 'Neo Hooke')
    filename = strcat('NeoH_', obstacleName, '_F', forceName, '_Lvl', level);
  elseif strcmp(materialName, 'St.Venant')
    filename = strcat('StVe_', obstacleName, '_F', forceName, '_Lvl', level);
  end
  mkdir('../Output/KonvPlots/Vergleich/');
  filepathOutput = strcat('../Output/KonvPlots/Vergleich/', filename, '.tex');
else
  filepathInput = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/Constant',forceName,'Force/',materialName,'/',contactName,'/Saves/');
  forceConv = load(strcat(filepathInput,'ForceConv',level,'.mat')).equilibriumConvergence;
  contactConv = load(strcat(filepathInput,'ContactConv',level,'.mat')).contactConvergence;
  dataList = {forceConv, contactConv};
  colorList = {'blue', 'red'};
  
  if strcmp(materialName, 'Linear elastisch')
    filename = strcat('LinE_', obstacleName, '_F', forceName, '_Lvl', level, '_', contactName);
  elseif strcmp(materialName, 'Neo Hooke')
    filename = strcat('NeoH_', obstacleName, '_F', forceName, '_Lvl', level, '_', contactName);
  elseif strcmp(materialName, 'St.Venant')
    filename = strcat('StVe_', obstacleName, '_F', forceName, '_Lvl', level, '_', contactName);
  end
  mkdir('../Output/KonvPlots/Einzel/');
  filepathOutput = strcat('../Output/KonvPlots/Einzel/', filename, '.tex');
end
writeTikzplot(filepathOutput, dataList, colorList);
end