function DlG = assembly_DlG(u, mesh, problem, solverPara)
% Compute the full Lagrange Matrix of given mesh and quad order

noVert = mesh.noVert;
noCVert = mesh.noCVert;
noCEdge = size(mesh.gammaCEdgeId,1);

%Assembly DlG
DlG = zeros(noVert*2,noCVert);
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    ids = [edge, edge + ones(1,2)*noVert];
    u_edge = u(ids);
    DlG_ed = assembly_DlG_edge(u_edge,edge, mesh, problem, solverPara);
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    DlG(ids,local_ids) = DlG(ids,local_ids) + DlG_ed;
end

DlG = sparse(DlG);
end

function DlG_ed = assembly_DlG_edge(u_edge, edge, mesh, problem, solverPara)
%computes the Lagrange Matrix B for a given edge element and quadrature

DlG_ed = zeros(4,2);
%Define Trafo
a = mesh.vertices(edge(1),:);
b = mesh.vertices(edge(2),:);
h = norm(b-a);
Trafo_det = h/2;

%Define u on edge
u_basis1 = displacement_basis_edge(1,0);
u_basis2 = displacement_basis_edge(2,0);
u_basis3 = displacement_basis_edge(3,0);
u_basis4 = displacement_basis_edge(4,0);
u_edge_func = @(s_hat) u_edge(1)*u_basis1(s_hat) + u_edge(2)*u_basis2(s_hat) ...
                     + u_edge(3)*u_basis3(s_hat) + u_edge(4)*u_basis4(s_hat);

gradGap = problem.gradGap;
for i = 1:4
    phi_i = displacement_basis_edge(i,0);
    %vielleicht ist auch noch die Kettenregel zu beachten!
    DG = @(s_hat) gradGap(trafo_from_ref_1d(s_hat,edge,mesh), u_edge_func(s_hat), phi_i(s_hat));
    for j = 1:2
        psi_j = mortar_basis(j,0);
        integrand = @(s_hat) psi_j(s_hat) * DG(s_hat) * Trafo_det; 
        DlG_ed(i,j) = quadrature1d(integrand, 2);
    end
end
end