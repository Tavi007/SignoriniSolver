function Dp = assembly_Dp(mesh, solverPara)
% Compute the full obstacle vector of given mesh and quad order
noCVert = mesh.noCVert;
noCEdge = size(mesh.gammaCEdgeId,1);


%Assembly Dp
Dp = zeros(noCVert,1);
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    Dp_ed = assembly_Dp_edge(edge, mesh, solverPara);
    
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    Dp(local_ids) = Dp(local_ids) + Dp_ed;
end
end

function Dp_ed = assembly_Dp_edge(edge, mesh, solverPara)
%computes the obstacle vector gB for a given edge element and quadrature

Dp_ed = zeros(2,1);
if size(edge,2) == 1 % if element is Id
    edge = mesh.edges(edge,:);
end
%Define Trafo
a = mesh.vertices(edge(1),:);
b = mesh.vertices(edge(2),:);
h = norm(b-a);
Trafo_det = h/2;

for j= 1:2
    psi_j = mortar_basis(j,0);%hier soll  die  massematrix von u rauskommen
    Dp_ed(j) = quadrature1d(psi_j, 1) * Trafo_det;    
end
end