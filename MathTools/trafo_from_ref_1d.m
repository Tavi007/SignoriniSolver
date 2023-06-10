function x = trafo_from_ref_1d(s_hat,edge,mesh)
%Transforms the coordinate x from reference intervall [-1,1] to the edge element c R^2.

a = mesh.vertices(edge(1),:);
b = mesh.vertices(edge(2),:);

x = ( (a+b) + s_hat*(b-a) )/2;

end

