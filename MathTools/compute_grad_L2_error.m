function error = compute_grad_L2_error(u, mesh)
%computes d1U1^2 + d1U2^2 + d1U3^2 + d2U1^2 + d2U2^2 + d2U3^2 + d3U1^2 + d3U2^2 + d3U3^2 
% with U = u_h - u_ana. Some values may be 0.

noVert = mesh.noVert;
noElem = mesh.noElem;

%Assembly error 
error = 0;
for e = 1:noElem %loop over elements
    element = mesh.elements(e,:);
    ids = [element, element+ones(1,3)*noVert];
    error_el = compute_grad_L2_error_element(u(ids), mesh, element);
    error = error + error_el; 
end

error = sqrt(error);
endfunction


function error_el = compute_grad_L2_error_element(u_elem, mesh, element)

[du1_dx, du1_dy, du2_dx, du2_dy] = get_special_gradSolution();
    
gradU_ana = @(x) [du1_dx(x), du1_dy(x), du2_dx(x), du2_dy(x)];   
error_el = 0;

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



%TrafoU=zeros(3);
%gradU_ana = @(x) [0, 0, 0, 0];  


%analytical solution. x-Value will be transformed to the real coordinates first.
gradU_ana_hat = @(x_hat) gradU_ana(trafo_from_ref_2d(x_hat,element,mesh));
gradU_sol = [TrafoU(1,1), TrafoU(2,1), TrafoU(1,2), TrafoU(2,2)]; %Matrix reassemble to vector
error_grad = @(x_hat) gradU_ana_hat(x_hat)-gradU_sol;
integrand = @(x_hat) (error_grad(x_hat)*error_grad(x_hat)') * TrafoDet; %remove point for sum

error_el = quadrature2d(integrand,4); %quadOrder = 4
endfunction

