function [] = print_mesh(mesh,graphic)
% Print the mesh. If graphic = 1, then the mesh will also be plotted

disp('Vertices')
disp(mesh.vertices)

disp('Edges')
disp(mesh.edges)

disp('Elements')
disp(mesh.elements)
end

