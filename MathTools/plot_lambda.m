function [] = plot_lambda(lambda, mesh, figure_number)
%Plot the Lagrange Multiplier lambda

EdgeId = mesh.gammaCEdgeId;
noEdgeId = length(EdgeId);
basis1 = mortar_basis(1,0);
basis2 = mortar_basis(2,0);

figure(figure_number)
for e = 1:noEdgeId
    edge = mesh.edges(mesh.gammaCEdgeId(e),:);
    vert1_x = mesh.vertices(edge(1),1);
    vert2_x = mesh.vertices(edge(2),1);
    
    [~, local_ids] = ismember(edge, mesh.gammaCVertId);
    lambda1 = lambda(local_ids(1));
    lambda2 = lambda(local_ids(2));
    lambda_func = @(s) lambda1*basis1(s) + lambda2*basis2(s);
    
    y1 = lambda_func(-1);
    y2 = lambda_func(1);    
    
    x_plot = [vert1_x; vert2_x];
    y_plot = [y1; y2];
    hold on
    plot(x_plot,y_plot,'-b')
end
xlabel('Rand \Gamma_C');
ylabel('Lagrange-Multiplikator \lambda');

end

