function DuF = assembly_DuF(u, material,mesh)
% Compute the full Matrix of given mesh and Energie function DF = DDPi(u)(v,w)

noVert = mesh.noVert;
noElem = mesh.noElem;

%Assembly A
DuF = sparse(zeros(noVert*2,noVert*2));
for e = 1:noElem
    element = mesh.elements(e,:);
    ids = [element, element+ones(1,3)*noVert];
    DuF_el = assembly_DuF_element(element, u(ids),material, mesh);
    DuF(ids,ids) = DuF(ids,ids) + DuF_el;
end

%Include Boundary condition
%Dirichlet
%DuF = include_bdr_conditions(DuF, mesh, 0);
end

function DuF_el = assembly_DuF_element(element, u_element,material, mesh)
%computes the Stiffness Matrix A for a given mesh element and quadrature
%according to the problem and material

DuF_el = zeros(6,6);
%Define Trafo
a1 = mesh.vertices(element(1),:)';
a2 = mesh.vertices(element(2),:)';
a3 = mesh.vertices(element(3),:)';
DTrafo = [[a2-a1, a3-a1], [0;0];
          [0,0]         , 1]; % x = DTrafo*x_hat + d
DTrafo_inv_T = (inv(DTrafo))';

%  muss da /2 hin oder nicht? 
TrafoDet = abs(det(DTrafo))/2; 
%TrafoDet = abs(det(DTrafo)); %Test 

allBasis=displacement_basis(7,1);
allBasisTrafo = DTrafo_inv_T*allBasis;
TrafoU=zeros(3);
for i=1:6
    TrafoBasis_i = allBasisTrafo(:,(i*3-2):i*3);
    TrafoU = TrafoU + u_element(i)*TrafoBasis_i; 
end


%loop over basisfunctions
for i = 1:6
    TrafoPhi_i = allBasisTrafo(:,(i*3-2):i*3);
    DS_R = material.Dsigma(TrafoU,TrafoPhi_i);
    for j= 1:6
        TrafoPhi_j = allBasisTrafo(:,(j*3-2):j*3);
        %DuF_el(i,j) = T2_colon_T2(DS_R(1:2,1:2) , TrafoPhi_j(1:2,1:2)) * TrafoDet;
        
        %Test
        epsilon = (TrafoPhi_j + TrafoPhi_j')/2;
        DuF_el(j,i) = T2_colon_T2(DS_R(1:2,1:2) , epsilon(1:2,1:2)) * TrafoDet;
    end
end
end
