function d = assembly_obstacle(u, mesh, problem, solverPara)
% Compute the full obstacle vector of given mesh and quad order

noVert = mesh.noVert;
noCVert = mesh.noCVert;
noCEdge = size(mesh.gammaCEdgeId,1);

%Assembly g
d = zeros(noCVert,1);
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    u_edge = [u(edge(1)), u(edge(2)), u(edge(1)+noVert), u(edge(2)+noVert)];
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    d_ed = assembly_obstacle_edge(u_edge, edge, mesh, problem, solverPara) ;
    d(local_ids) = d(local_ids) + d_ed;
end
end

function d_ed = assembly_obstacle_edge(u_edge, edge, mesh, problem, solverPara)
%computes the value for a given contact vertex on the element with quadrature

d_ed =zeros(2,1);
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

gap = problem.gap;
%vielleicht ist auch noch die Kettenregel zu beachten!
D = @(s_hat) gap(trafo_from_ref_1d(s_hat,edge,mesh), u_edge_func(s_hat));
for j= 1:2
    psi_j = mortar_basis(j,0);
    integrand = @(s_hat) psi_j(s_hat) * D(s_hat);
    d_ed(j) = quadrature1d(integrand, 2) * Trafo_det;
end
end