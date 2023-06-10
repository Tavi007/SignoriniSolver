%writeVTKObstacle(filename, mesh, problem)
% vtk export of Obstacle  


disp('Saving start')
addpath('../Assembly','../Material','../Material/Tools','../MathTools','../Mesh','../Problem','../Solver');
domainName = 'Rechteck';          % Quad, Deformed_Quad, LDomain, 
obstacleName = 'Special';        % None, Platt, Linie, Parabel, Spitze, Hut


%must 3 dimensional. (with y value is upwards and x sideways)
volumeForce = @(x) [0;-20;0]; 
solverPara.linearContact=1;
forceName = 'Constant20';

problem = load_problem(domainName, obstacleName, volumeForce, forceName, solverPara);
mesh = load(strcat('../Mesh/Files/', domainName, '/level5.mat'));
mesh = set_boundary(mesh, problem);

filepath = strcat('../Output/', domainName, 'Domain/', obstacleName, 'Obstacle/');
filename = strcat(filepath,'Obstacle');
mkdir(filename);
 
CEdgeId = mesh.gammaCEdgeId;
noCEdge = length(CEdgeId);
noCVert = mesh.noCVert;
obstacle_func = problem.obstacle;
verts = [];
CEdgeId_spez = [];
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    vert1_x = mesh.vertices(edge(1),1);
    vert2_x = mesh.vertices(edge(2),1);
    
    vert1_y = obstacle_func(vert1_x);
    vert2_y = obstacle_func(vert2_x);    
    
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

fclose(FID);

disp('Saving done')