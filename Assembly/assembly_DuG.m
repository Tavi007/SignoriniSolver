function DuG = assembly_DuG(u, lambda, mesh, problem, solverPara)
% Compute the full Lagrange Matrix of given mesh and quad order

noVert = mesh.noVert;
noCEdge = size(mesh.gammaCEdgeId,1);

%Assembly DuG
DuG = sparse(zeros(noVert*2,noVert*2));
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    ids = [edge, edge + noVert];
    u_edge = u(ids);
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    lambda_edge = lambda(local_ids);
    
    DuG_ed = assembly_DuG_edge(u_edge, lambda_edge, edge, mesh, problem, solverPara);
    
    DuG(ids,ids) = DuG(ids,ids) + DuG_ed;
end
end

function DuG_ed = assembly_DuG_edge(u_edge, lambda_edge, edge, mesh, problem, solverPara)
%computes the Lagrange Matrix B for a given edge element and quadrature

DuG_ed = zeros(4,4);
%Define Trafo
a = mesh.vertices(edge(1),:);
b = mesh.vertices(edge(2),:);
h = norm(b-a);
Trafo_det = h/2; %koennte falsch sein!!!!

%Define u on edge
u_basis1 = displacement_basis_edge(1,0);
u_basis2 = displacement_basis_edge(2,0);
u_basis3 = displacement_basis_edge(3,0);
u_basis4 = displacement_basis_edge(4,0);
u_edge_func = @(s_hat) u_edge(1)*u_basis1(s_hat) + u_edge(2)*u_basis2(s_hat) ...
                     + u_edge(3)*u_basis3(s_hat) + u_edge(4)*u_basis4(s_hat);
   
%Define lambda on edge
lambda_basis1 = mortar_basis(1,0);
lambda_basis2 = mortar_basis(2,0);
lambda_edge_func = @(s_hat) lambda_edge(1)*lambda_basis1(s_hat) + lambda_edge(2)*lambda_basis2(s_hat);

gradGradGap = problem.gradGradGap;
for i = 1:2 %for i=3,4 DG will be 0 anyway
    phi_i = displacement_basis_edge(i,0);
    for j= 1:2 %for j=3,4 DG will be 0 anyway
        phi_j = displacement_basis_edge(j,0);
        %vielleicht ist auch noch die Kettenregel zu beachten!
        DG = @(s_hat) gradGradGap(trafo_from_ref_1d(s_hat,edge,mesh), u_edge_func(s_hat), phi_i(s_hat), phi_j(s_hat));
        
        zwsp = DG(0);
        integrand = @(s_hat) lambda_edge_func(s_hat) * DG(s_hat) * Trafo_det;
        DuG_ed(i,j) = quadrature1d(integrand, 2);
    end
end
end