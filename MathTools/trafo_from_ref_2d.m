function x = trafo_from_ref_2d(x_hat,element,mesh)
%Transforms the coordinate x from reference element to the mesh element.

if size(element,2) == 3 % element is the vertices triple
a1 = mesh.vertices(element(1),:);
a2 = mesh.vertices(element(2),:);
a3 = mesh.vertices(element(3),:);
elseif size(element,2) == 1 %element is the element Id
a1 = mesh.vertices(mesh.element(element,1),:);
a2 = mesh.vertices(mesh.element(element,2),:);
a3 = mesh.vertices(mesh.element(element,3),:);
else
    error('Unknown element definition');
end
d = a1';
B = [a2'-a1', a3'-a1'];

x = B*x_hat'+d;
end