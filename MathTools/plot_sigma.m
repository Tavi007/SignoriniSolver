function [] = plot_sigma(u, Sigma, mesh, problem)
%plot the deformed body

X = mesh.vertices(:,1);
Y = mesh.vertices(:,2);

noElem = mesh.noElem;
noVert = mesh.noVert;

X_plot = zeros(3,noElem);
Y_plot = X_plot;
Sigma_plot = zeros(4, noElem);


%get plot data
for e = 1 :noElem
    element = mesh.elements(e,:);
    sigma_R = evaluateStress(u, Sigma, element, mesh);
    ids = [ element, ones(1,3)*noVert + element];
    u_el = u(ids); 
    
    X_plot(:,e) = X(element)+u_el(1:3);
    Y_plot(:,e) = Y(element)+u_el(4:6);
    
    Sigma_plot(1,e) = sigma_R(1,1);
    Sigma_plot(2,e) = sigma_R(2,2);
    Sigma_plot(3,e) = sigma_R(3,3);
    Sigma_plot(4,e) = sigma_R(1,2); 
end

%plot the membran with sigma
for i=1:1
    figure(i)
    colormap (jet (64));
    for e = 1 :noElem
        patch(X_plot(:,e), Y_plot(:,e), Sigma_plot(i,e), 'EdgeColor','none')
    end
end

%set Title
for i = 1:1
    figure(i)
    title(strcat('Spannung \sigma_{',num2str(11*i),'}'))
    colorbar
end

%figure(4)
%title(strcat('Spannung \sigma_{',num2str(12),'}'))

%fix the colorbar scaling!!
colorbar

if ~isempty(mesh.gammaCEdgeId) %if obstacle exist
    for i = 1:1
        figure(i)
        hold on
        plot_obstacle(problem)
    end  
end
end

