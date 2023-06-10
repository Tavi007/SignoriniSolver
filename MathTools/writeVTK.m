function writeVTK(filepathSolution, mesh, u, lambda, material, problem, solverPara)
% vtk export for u_h, sigma and epsilon

elements = mesh.elements;
noVert = size(mesh.vertices,1);
noElem = size(elements,1);
u_refractor = [u(1:noVert), u(noVert + 1: noVert*2)];
verts = mesh.vertices + u_refractor;

switch solverPara.contactType
case 'linear'
    switch material.law
    case 'Linear elastisch'
        name = 'LinEla_LinC';
    case 'St.Venant'
        name = 'Venant_LinC';
    case 'Neo Hooke'
        name = 'NeoHke_LinC';
    end
case 'non linear'
    switch material.law
    case 'Linear elastisch'
        name = 'LinEla_GenC';
    case 'St.Venant'
        name = 'Venant_GenC';
    case 'Neo Hooke'
        name = 'NeoHke_GenC';
    end
case 'linear normiert'
    switch material.law
    case 'Linear elastisch'
        name = 'LinEla_LinC_N';
    case 'St.Venant'
        name = 'Venant_LinC_N';
    case 'Neo Hooke'
        name = 'NeoHke_LinC_N';
    end
end
filename = strcat(filepathSolution, 'u_', name, num2str(mesh.level));

%compute values to be saved
Epsilon = zeros(noElem,4);
Sigma = zeros(noElem,4);

if strcmp(material.law,'linearElastic')
    [E, ~, ~] = strainLinear();
else
    [E, ~, ~] = strain();
end

for e = 1:mesh.noElem
    element = mesh.elements(e,:);
    
    Epsilon_zwsp = evaluateStress(u, E, element, mesh); %kinda cheated, but does the right thing
    epsilon(e,1) = Epsilon_zwsp(1,1);
    epsilon(e,2) = Epsilon_zwsp(2,2);
    epsilon(e,3) = Epsilon_zwsp(3,3);
    epsilon(e,4) = Epsilon_zwsp(1,2);
    
    sigma_R = evaluateStress(u, material.sigma, element, mesh);
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
fprintf(FID, s, u_refractor');
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


if mesh.noCVert ~= 0 %With Contact
    filenameLambda = strcat(filepathSolution, 'lmd_', name, num2str(mesh.level));
    writeVTKLambda(filenameLambda, mesh, lambda);
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writeVTKLambda(filename, mesh, lambda)
% vtk export of Lambda  
  
CEdgeId = mesh.gammaCEdgeId;
noCEdge = length(CEdgeId);
noCVert = mesh.noCVert;
basis1 = mortar_basis(1,0);
basis2 = mortar_basis(2,0);
verts = [];
CEdgeId_spez = [];
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    vert1_x = mesh.vertices(edge(1),1);
    vert2_x = mesh.vertices(edge(2),1);
    
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    lambda1 = lambda(local_ids(1));
    lambda2 = lambda(local_ids(2));
    lambda_func = @(s) lambda1*basis1(s) + lambda2*basis2(s);
    
    vert1_y = lambda_func(-1);
    vert2_y = lambda_func(1);    
    
    verts = [verts;
             vert1_x, vert1_y;
             vert2_x, vert2_y];
    CEdgeId_spez = [CEdgeId_spez;
                    e*2-1, e*2];
end
noVerts = size(verts,1);
    
%Header
FID = fopen(strcat(filename,'.vtk'),'w+');
fprintf(FID,'# vtk DataFile Version 2.0\nUnstructured Grid Example\nASCII\n');
fprintf(FID,'DATASET UNSTRUCTURED_GRID\n');
fprintf(FID,'\n');

%Points
fprintf(FID,'POINTS %d float\n', noVerts);
s = '%f %f %f \n';
allVerts = [verts, zeros(noVerts,1)]';
fprintf(FID, s, allVerts);
fprintf(FID,'\n');

%Cells
fprintf(FID,'CELLS %d %d\n', noCEdge, noCEdge*(3));
s='%d ';
for k=1:2
    s=horzcat(s,{' %d'});
end
s=cell2mat(horzcat(s,{' \n'}));
fprintf(FID, s, [(2)*ones(noCEdge,1), CEdgeId_spez-1]');
fprintf(FID,'\n');

%Cell type
fprintf(FID, 'CELL_TYPES %d\n', noCEdge);
s='%d\n';
fprintf(FID, s, 3*ones(noCEdge,1));
fprintf(FID,'\n');

%Point Data 
s='%d\n';
fprintf(FID, 'POINT_DATA %s\n', num2str(noVerts));
fprintf(FID,'\n');
%lambda_h
fprintf(FID,'SCALARS lambda_h float 1\nLOOKUP_TABLE default\n', num2str(noVerts));
s='%f \n';
fprintf(FID, s, verts(:,2)');
fprintf(FID,'\n');

fclose(FID);
end
