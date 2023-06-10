function Sigma = evaluateStress(u, Stress, element, mesh)
%evaluate the the stress of a given deformation and on a given element 

ids = [ element, ones(1,3)*mesh.noVert + element];
u_element = u(ids);

%Define Trafo
a1 = mesh.vertices(element(1),:)' + [u_element(1); u_element(4)];
a2 = mesh.vertices(element(2),:)' + [u_element(2); u_element(5)];
a3 = mesh.vertices(element(3),:)' + [u_element(3); u_element(6)];
DTrafo = [[a2-a1, a3-a1], [0;0];
          [0,0]         , 1]; % x = DTrafo*x_hat + d
DTrafo_inv_T = inv(DTrafo)';

%get Transformed gradU
allBasis=displacement_basis(7,1);
allBasisTrafo = DTrafo_inv_T*allBasis;
TrafoU=zeros(3);
for i=1:6
    TrafoBasis_i = allBasisTrafo(:,(i*3-2):i*3);
    TrafoU = TrafoU + u_element(i)*TrafoBasis_i; 
end

%Sigma_R = Stress(gradU_el) %fuer bunte Bilder
Sigma = Stress(TrafoU);
end

