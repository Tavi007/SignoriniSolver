function F = assembly_F(u,material,mesh,problem)
% Compute the RHS for given F

noVert = mesh.noVert;
noElem = mesh.noElem;

%Assembly rhs 
F = zeros(noVert*2,1);
for e = 1:noElem
    element = mesh.elements(e,:);
    ids = [element, element+ones(1,3)*noVert];
    rhs_def_el = assembly_deformation_element(element, u(ids), material, mesh);
    rhs_vol_el = assembly_volumeforce_element(element, mesh, problem);
    F(ids) = F(ids) - rhs_vol_el + rhs_def_el; 
end

%Include Boundary condition
%Dirichlet
F = include_bdr_conditions(F, mesh, problem);
end

function rhs_def_el = assembly_deformation_element(element, u_element, material,mesh)
%computes the rhs (deformation) for a given mesh element and quadrature

rhs_def_el = zeros(6,1);

%Define Trafo
a1 = mesh.vertices(element(1),:)';
a2 = mesh.vertices(element(2),:)';
a3 = mesh.vertices(element(3),:)';
DTrafo = [[a2-a1, a3-a1], [0;0];
          [0,0]         , 1]; % x = DTrafo*x_hat + d
DTrafo_inv_T = (inv(DTrafo))';


%  muss da /2 hin oder nicht? Weiter unten ist ein ähnlicher Fall
TrafoDet = abs(det(DTrafo))/2;
%TrafoDet = abs(det(DTrafo)); %Test 

allBasis=displacement_basis(7,1);
allBasisTrafo = DTrafo_inv_T*allBasis;
TrafoU=zeros(3);
for i=1:6
    TrafoBasis_i = allBasisTrafo(:,(i*3-2):i*3);
    TrafoU = TrafoU + u_element(i)*TrafoBasis_i; 
end
S_R = material.sigma(TrafoU);

%loop over basisfunctions
for i = 1:6
    TrafoPhi_i = allBasisTrafo(:,(i*3-2):i*3);
    %rhs_def_el(i) = T2_colon_T2(S_R(1:2,1:2) , TrafoPhi_i(1:2,1:2)) * TrafoDet;
    
    %Test
    epsilon = (TrafoPhi_i + TrafoPhi_i')/2;
    rhs_def_el(i) = T2_colon_T2(S_R(1:2,1:2) , epsilon(1:2,1:2)) * TrafoDet;
end

end

function F_vol_el = assembly_volumeforce_element(element, mesh, problem)
%computes the rhs (volumeforce) for a given mesh element and quadrature
%also depends on the given problem

F_vol_el = zeros(6,1);

f_hat = @(x_hat) problem.force(trafo_from_ref_2d(x_hat,element,mesh)); %transformed f

%Define Trafo
a1 = mesh.vertices(element(1),:)';
a2 = mesh.vertices(element(2),:)';
a3 = mesh.vertices(element(3),:)';
DTrafo = [[a2-a1, a3-a1], [0;0];
          [0,0]         , 1]; % x = DTrafo*x_hat + d
          
          
%  muss da /2 hin oder nicht? Hier ist bereits ein abs() drum. 
TrafoDet = abs(det(DTrafo)); 
%TrafoDet = abs(det(DTrafo))/2; %Test 

%loop over basisfunctions
for i = 1:6
    phi_i = displacement_basis(i,0);
    integrand = @(x_hat) f_hat(x_hat)' * phi_i(x_hat) * TrafoDet;
    F_vol_el(i) = quadrature2d(integrand,4); %quadOrder = 4
end
end