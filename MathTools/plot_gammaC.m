function plot_gammaC(mesh)
noCEdge = mesh.noCEdge;

x_plot = [];
y_plot = [];
colors = ['r', 'g', 'b'];
noC = length(colors);
for e = 1:noCEdge
    CEdge = mesh.edges(mesh.gammaCEdgeId(e),:);
    CVert1 = mesh.vertices(CEdge(1),:);
    CVert2 = mesh.vertices(CEdge(2),:);
    
    x_plot = [CVert1(1), CVert2(1)];
    y_plot = [CVert1(2)+ e/noCEdge, CVert2(2)+ e/noCEdge];
    
    plot(x_plot, y_plot, colors(mod(e,noC)+1) )
    hold on
end


end
