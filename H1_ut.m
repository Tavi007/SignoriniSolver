% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

mesh.vertices = [0, 1;
                 1, 0;
                -1, 0];
mesh.elements = [1, 2, 3];
u = [1, 2, 3, 0, 0, 0];

noVert = 3;
noElem = 1;

%Assembly error 
error = 0;
for e = 1:noElem %loop over elements
    element = mesh.elements(e,:);
    ids = [element, element+ones(1,3)*noVert]; 
    u_elem = u(ids);
    
    
    %Define Trafo
    a1 = mesh.vertices(element(1),:)';
    a2 = mesh.vertices(element(2),:)';
    a3 = mesh.vertices(element(3),:)';
    DTrafo = [[a2-a1, a3-a1], [0;0];
              [0,0]         , 1]; % x = DTrafo*x_hat + d
    DTrafo_inv_T = (inv(DTrafo))';
    TrafoDet = abs(det(DTrafo));
    
    %Define gradient of solution on reference triangle
    allGradBasis=displacement_basis(7,1);
    allBasisTrafo = DTrafo_inv_T*allGradBasis; %transform gradient basis
    TrafoU=zeros(3);
    for i=1:6
        TrafoBasis_i = allBasisTrafo(:,(i*3-2):i*3); %cut the right basis out of allBasisTrafo
        TrafoU = TrafoU + u_elem(i)*TrafoBasis_i; 
    end
    
    integrand = @(x_hat) T2_colon_T2(TrafoU, TrafoU) * TrafoDet;
    
    error_el = quadrature2d(integrand,2); %quadOrder = 4
    error = error + error_el; 
end

error
