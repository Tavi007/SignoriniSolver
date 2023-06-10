function Du_dA = assembly_DudA(u, set_A_local, mesh, problem, solverPara)
%Assembly Du_gA
set_A_global = mesh.gammaCVertId(set_A_local);
dimA=length(set_A_global);
Du_dA = zeros(dimA,mesh.noVert*2);
for i = 1:dimA
    Du_dA_CVert = assembly_DudA_vert(u, set_A_global(i), mesh, problem, solverPara); %nonlinear contact 
    Du_dA(i,:) = Du_dA_CVert;
end
end

function Du_dA_CVert = assembly_DudA_vert(u, active_vertID, mesh, problem, solverPara)
%computes the value for a given contact vertex on the element with quadrature

noCEdge = size(mesh.gammaCEdgeId,1);
noVert = mesh.noVert;

Du_dA_CVert = zeros(1,noVert*2);
for e = 1:noCEdge
    CEdge = mesh.edges(mesh.gammaCEdgeId(e),:);
    [found, index] = ismember(active_vertID, CEdge);
    if found
        ids = [CEdge(1), CEdge(2), CEdge(1)+noVert, CEdge(2)+noVert];
        psi_i = mortar_basis(index,0);
        
        %Define Trafo
        a = mesh.vertices(CEdge(1),:);
        b = mesh.vertices(CEdge(2),:);
        h = norm(b-a);
        Trafo_det = h/2; %koennte falsch sein!!!!
        
        %Define u on edge
        u_basis1 = displacement_basis_edge(1,0);
        u_basis2 = displacement_basis_edge(2,0);
        u_basis3 = displacement_basis_edge(3,0);
        u_basis4 = displacement_basis_edge(4,0);
        u_edge_func = @(s_hat) u(ids(1))*u_basis1(s_hat) + u(ids(2))*u_basis2(s_hat) ...
        + u(ids(3))*u_basis3(s_hat) + u(ids(4))*u_basis4(s_hat);
        
        gradGap = problem.gradGap;
        
        for j = 1:4
            phi_j = displacement_basis_edge(j,0);
            DuD = @(s_hat) gradGap(trafo_from_ref_1d(s_hat,CEdge,mesh), u_edge_func(s_hat), phi_j(s_hat));
            integrand = @(s_hat) psi_i(s_hat) * DuD(s_hat);
            Du_dA_CVert(1,ids(j)) = Du_dA_CVert(1,ids(j)) + quadrature1d(integrand, 2) * Trafo_det;
        end
    end
end
end