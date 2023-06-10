function error = compute_HHalf_edge_error(lambda,mesh)
% Compute the H^-1/2 norm

noVert = mesh.noVert;
noCVert = mesh.noCVert;
noCEdge = size(mesh.gammaCEdgeId,1);

error = 0;
for e = 1:noCEdge
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    ids = [e, e+1];
    lambda_edge = lambda(ids);
    error_ed = compute_HHalf_edge_error_edge(lambda_edge, edge, mesh);
    error = error + error_ed;
end

error = sqrt(error);
end

function error_ed = compute_HHalf_edge_error_edge(lambda_edge, edge, mesh)


%Define Trafo
a = mesh.vertices(edge(1),:);
b = mesh.vertices(edge(2),:);
h = norm(b-a);
Trafo_det = h/2;

%Define u on edge
m_basis1 = mortar_basis(1,0);
m_basis2 = mortar_basis(2,0);
lambda_hat_num = @(s_hat) lambda_edge(1)*m_basis1(s_hat) + lambda_edge(2)*m_basis2(s_hat);

lambda_ana = get_special_lagrange();
lambda_hat_ana = @(s_hat) lambda_ana(trafo_from_ref_1d(s_hat,edge,mesh));

integrand = @(s_hat) (lambda_hat_num(s_hat) - lambda_hat_ana(s_hat) )^2 * Trafo_det; 
error_ed = quadrature1d(integrand, 2); % '*h' to get from the L2(gamma_C) to H^1/2(gamma_C)
end