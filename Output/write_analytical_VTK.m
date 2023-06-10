addpath('../Assembly','../Material','../Material/Tools','../MathTools','../Mesh','../Problem','../Solver');

level = 0;
filename = strcat('../Output/RechteckDomain/SpecialObstacle/SpecialForce/u_analytisch', num2str(level));
mesh = load(strcat('../Mesh/Files/Rechteck/level', num2str(level), '.mat'));
u = get_special_solution();
u_x = [];
u_y = [];

for i = 1:mesh.noVert
    vert = mesh.vertices(i,:);
    u_value = u(vert);
    u_x = [u_x; u_value(1)];
    u_y = [u_y; u_value(2)];
end

u_ana = [u_x, u_y];
elements = mesh.elements;
noVert = size(mesh.vertices,1);
noElem = size(elements,1);
verts = mesh.vertices + u_ana;
E=10;
nu=0.3;
material.para.lambda = nu/(1-2*nu)/(1+nu)*E;
material.para.mu = E/(2+2*nu);

material.law = 'Linear elastisch';
[material.sigma, material.Dsigma] = linearElastic(material.para);

%compute values to be saved
epsilon = zeros(noElem,4);
sigma = zeros(noElem,4);
[E, ~, ~] = strainLinear();

for e = 1:noElem
    element = mesh.elements(e,:);
    
    Epsilon_zwsp = evaluateStress(u_ana, E, element, mesh); %kinda cheated, but does the right thing
    epsilon(e,1) = Epsilon_zwsp(1,1);
    epsilon(e,2) = Epsilon_zwsp(2,2);
    epsilon(e,3) = Epsilon_zwsp(3,3);
    epsilon(e,4) = Epsilon_zwsp(1,2);
    
    sigma_R = evaluateStress(u_ana, material.sigma, element, mesh);
    sigma(e,1) = sigma_R(1,1);
    sigma(e,2) = sigma_R(2,2);
    sigma(e,3) = sigma_R(3,3);
    sigma(e,4) = sigma_R(1,2);
end
%Header
FID = fopen(strcat(filename,'.vtk'),'w+');
fprintf(FID,'# vtk DataFile Version 2.0\nUnstructured Grid Example\nASCII\n');
fprintf(FID,'DATASET UNSTRUCTURED_GRID\n');
fprintf(FID,'\n');

%Points
fprintf(FID,'POINTS %d float\n', noVert);
s = '%f %f %f \n';
allVerts = [verts, zeros(size(verts,1),1)]';
fprintf(FID, s, allVerts);
fprintf(FID,'\n');

%Cells
fprintf(FID,'CELLS %d %d\n', noElem, noElem*(4));
s='%d ';
for k=1:3
    s=horzcat(s,{' %d'});
end
s=cell2mat(horzcat(s,{' \n'}));
fprintf(FID, s, [(3)*ones(noElem,1), elements-1]');
fprintf(FID,'\n');

%Cell type
fprintf(FID, 'CELL_TYPES %d\n', noElem);
s='%d\n';
fprintf(FID, s, 5*ones(noElem,1));
fprintf(FID,'\n');

%Point Data 
s='%d\n';
fprintf(FID, 'POINT_DATA %s\n', num2str(noVert));
fprintf(FID,'\n');
%u_h
fprintf(FID,'SCALARS u_h float 2\nLOOKUP_TABLE default\n', num2str(noVert));
s='%f %f \n';
fprintf(FID, s, u_ana');
fprintf(FID,'\n');

%Cell Data
fprintf(FID, 'CELL_DATA %s\n', num2str(noElem));
fprintf(FID,'\n');
%epsilon
fprintf(FID,'SCALARS epsilon float 4\nLOOKUP_TABLE default\n', num2str(noElem));
s='%f %f %f %f\n';
fprintf(FID, s, epsilon');
fprintf(FID,'\n');
%sigma
fprintf(FID,'SCALARS sigma float 4\nLOOKUP_TABLE default\n', num2str(noElem));
s='%f %f %f %f\n';
fprintf(FID, s, sigma');
fprintf(FID,'\n');

fclose(FID);
