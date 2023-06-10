function error = compute_L2_error(u, mesh)

noVert = mesh.noVert;
noElem = mesh.noElem;

%Assembly error 
error = 0;
for e = 1:noElem
    element = mesh.elements(e,:);
    ids = [element, element+ones(1,3)*noVert];
    error_el = compute_L2_error_element(u(ids), mesh, element);
    error = error + error_el; 
end

error = sqrt(error);
endfunction


function error_el = compute_L2_error_element(u_elem, mesh, element)

[u1,u2] = get_special_solution();
u_ana = @(x) [u1(x); u2(x); 0];
error_el = 0;

%Define Trafo
a1 = mesh.vertices(element(1),:)';
a2 = mesh.vertices(element(2),:)';
a3 = mesh.vertices(element(3),:)';
DTrafo = [[a2-a1, a3-a1], [0;0];
          [0,0]         , 1]; % x = DTrafo*x_hat + d
DTrafo_inv_T = (inv(DTrafo))';
TrafoDet = abs(det(DTrafo));

basis_1 = displacement_basis(1,0);
basis_2 = displacement_basis(2,0);
basis_3 = displacement_basis(3,0);
basis_4 = displacement_basis(4,0);
basis_5 = displacement_basis(5,0);
basis_6 = displacement_basis(6,0);
u_num_hat = @(x_hat) basis_1(x_hat)*u_elem(1) + basis_2(x_hat)*u_elem(2) ...
                   + basis_3(x_hat)*u_elem(3) + basis_4(x_hat)*u_elem(4) ...
                   + basis_5(x_hat)*u_elem(5) + basis_6(x_hat)*u_elem(6);

u_ana_hat = @(x_hat) u_ana(trafo_from_ref_2d(x_hat,element,mesh));

integrand = @(x_hat) norm(u_num_hat(x_hat) - u_ana_hat(x_hat))^2 * TrafoDet;

error_el = quadrature2d(integrand,4); %quadOrder = 4
endfunction

