function [projectionMatrix, projectionVector] = assembly_projection(lambda_coarse, mesh_coarse, mesh_thin)
    
noCoarseCEdges = mesh_coarse.noCEdge;
noThinCEdges = mesh_thin.noCEdge;
elementProjectionMatrix = zeros(3,3);
projectionMatrix = zeros(noThinCEdges+1, noThinCEdges+1);
projectionVector = zeros(noThinCEdges+1,1);
%manuell quadrature
coordinates = [-0.5-sqrt(1/12); -0.5+sqrt(1/12); 0.5-sqrt(1/12); 0.5+sqrt(1/12)];
%weigths = [1; 1;1;1]; %no need for use
basis_1 = mortar_basis(1,0);
basis_2 = mortar_basis(2,0);

for e = 1:noCoarseCEdges
    elementProjectionVector = zeros(3,1);
    elementProjectionMatrix = zeros(3,3);
    edge = mesh_coarse.edges(mesh_coarse.gammaCEdgeId(e),:);
    a = mesh_coarse.vertices(edge(1),:);
    b = mesh_coarse.vertices(edge(2),:);
    Trafo_det = norm(b-a)/2; 
    
    lambda_coarse_func = @(s_hat) lambda_coarse(e)*basis_1(s_hat) + lambda_coarse(e+1)*basis_2(s_hat);
    
    for i = 1:3
        basis_thin_i = mortar_basis_thin(i);
        for q = 1:4
            elementProjectionVector(i) = elementProjectionVector(i) + basis_thin_i(coordinates(q))*lambda_coarse_func(coordinates(q))*Trafo_det;
        end
        for j=1:3
            basis_thin_j = mortar_basis_thin(j);
            for q = 1:4
                elementProjectionMatrix(i,j) = elementProjectionMatrix(i,j) + basis_thin_i(coordinates(q))*basis_thin_j(coordinates(q))*Trafo_det;
            end
        end
    end
    
    projectionMatrix(e*2-1:e*2+1,e*2-1:e*2+1) = projectionMatrix(e*2-1:e*2+1,e*2-1:e*2+1) + elementProjectionMatrix;
    projectionVector(e*2-1:e*2+1) = projectionVector(e*2-1:e*2+1) + elementProjectionVector;
    
end
end
