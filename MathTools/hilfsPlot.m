function hilfsPlot(u, mesh, problem,figureNumber)

X = mesh.vertices(:,1);
Y = mesh.vertices(:,2);

noElem = mesh.noElem;
noVert = mesh.noVert;
figure(figureNumber);
for e = 1 :noElem
    element = mesh.elements(e,:);
    ids = [ element, ones(1,3)*noVert + element];
    u_el = u(ids);
    
    patch(X(element)+u_el(1:3),Y(element)+u_el(4:6),e, 'EdgeColor','none')
end
hold on
if mesh.noCVert ~= 0
    plot_obstacle(problem)
end
end