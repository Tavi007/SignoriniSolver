% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('../Assembly','../MathTools','../Mesh','../Problem');

%For loading data
obstacleName = 'Hut';           %'Parabel', 'Spitze', 'Hut'
forceName = 'Constant15';           %'Constant10', 'Constant15', 'Constant20'
materialName = 'Linear elastisch';  %'Linear elastisch', 'Neo Hooke', 'St.Venant'
contactName = 'genC';
level = '5';

if strcmp(materialName, 'Linear elastisch')
    filename = strcat('LinE_', obstacleName, '_', forceName, '_Lvl', level, '_', contactName);
  elseif strcmp(materialName, 'Neo Hooke')
    filename = strcat('NeoH_', obstacleName, '_', forceName, '_Lvl', level, '_', contactName);
  elseif strcmp(materialName, 'St.Venant')
    filename = strcat('StVe_', obstacleName, '_', forceName, '_Lvl', level, '_', contactName);
  end
  mkdir('../Output/Lambda/');
filepathOutput = strcat('../Output/Lambda/',filename,'.tex');

%loading data
filepathInput = strcat('../Output/QuadDomain/',obstacleName,'Obstacle/',forceName,'Force/',materialName,'/', contactName,'/Saves/');
lambda = load(strcat(filepathInput,'lmd',level,'.mat')).lambda_sol;
mesh = load(strcat('../Mesh/Files/Quad/level', level, '.mat'));
solverPara.linearContact =true;
volumeForce = @(x) [0,0,0];
problem = load_problem('Quad', obstacleName, volumeForce, forceName, solverPara);
mesh = set_boundary(mesh, problem);
EdgeId = mesh.gammaCEdgeId;
noEdgeId = length(EdgeId);
basis1 = mortar_basis(1,0);
basis2 = mortar_basis(2,0);

x_plot = [];
y_plot = [];
  
%Compute lambda values
for e = 1:noEdgeId
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    vert1_x = mesh.vertices(edge(1),1);
    vert2_x = mesh.vertices(edge(2),1);
    
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    lambda1 = lambda(local_ids(1));
    lambda2 = lambda(local_ids(2));
    lambda_func = @(s) lambda1*basis1(s) + lambda2*basis2(s);
    
    y1 = lambda_func(-1);
    y2 = lambda_func(1);    
    
    x_plot = [x_plot; vert1_x; vert2_x];
    y_plot = [y_plot; y1; y2];
end

ymin = min(y_plot);
ymax = max(y_plot);

%Header of file
%Open file
FID = fopen(filepathOutput,'w+');
%Header
fprintf(FID, '\\begin{tikzpicture}[every plot/.append style={thick}] \n');
fprintf(FID, '\\begin{axis}[ \n');
fprintf(FID, 'label style={font=\\normalsize}, \n');
fprintf(FID, 'xlabel={Kontaktrand $\\Gamma_C$}, \n');
fprintf(FID, 'ylabel={$\\lambda_h$}, \n');
fprintf(FID, 'xmin=0, xmax=1, \n');
fprintf(FID, 'ymin=%f, ymax=%f, \n', ymin, ymax);       
fprintf(FID, 'width=0.9\\textwidth, \n');
fprintf(FID, 'grid style=dashed, \n');
fprintf(FID, '] \n');

%values
for i=1:2:length(x_plot)
    fprintf(FID, '\\addplot[color=blue] coordinates {(%f,%f) ', x_plot(i),y_plot(i));
    fprintf(FID, '(%f,%f) }; \n', x_plot(i+1),y_plot(i+1));
end

%end tikz
fprintf(FID, '\\end{axis} \n');
fprintf(FID, '\\end{tikzpicture} \n');
fclose(FID);