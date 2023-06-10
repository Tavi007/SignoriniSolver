function x_hat = trafo_to_ref_2d(x,element,mesh)
%Transforms the coordinate x from the mesh element to the reference element

if size(element,2) == 3 % element is the vertices triple
a1 = mesh.vertices(element(1));
a2 = mesh.vertices(element(2));
a3 = mesh.vertices(element(3));
elseif size(element,2) == 1 %element is the element Id
a1 = mesh.vertices(mesh.element(element,1));
a2 = mesh.vertices(mesh.element(element,2));
a3 = mesh.vertices(mesh.element(element,3));
else
    error('Unknown element definition');
end
d = a1';
B = [a2'-a1', a3'-a1'];
B_inv = [B(2,2), -B(1,2);
         -B(2,1), B(1,1)]/det(B);

x_hat = B_inv*(x'-d);
end

