function [mesh] = refine_mesh(mesh)
% refines the mesh by halfing the meshsize
noElem = mesh.noElem;
oldElements = mesh.elements;
noOldVert = mesh.noVert;

mesh.edges = [];
mesh.elements = [];
mesh.newVertInfo = [];

disp(strcat('Anzahl Elemente: ', num2str(noElem)))
% loop Elements
% =============
for i = 1:noElem
    %refine Element
    [mesh] = refine_element(oldElements(i,:), mesh, noOldVert);
    if (mod(i,100) == 0)
      disp(strcat(num2str(i), '/', num2str(noElem), ' elements are done'))
    end
end
end

function [mesh] = refine_element(element, mesh, noOldVert)
%Refines an element

%New Vertices
new_vert=[];
for i = 1:3
    a = mesh.vertices(element(i),:);
    b = mesh.vertices(element(mod(i,3)+1),:);
    newVertex = b + (a - b)/2;
    new_vert = [new_vert; newVertex];
    %check if new vertex exist
    if get_vert_id(newVertex,mesh, noOldVert) == 0
        mesh.vertices = [mesh.vertices; newVertex];
        mesh.newVertInfo = [mesh.newVertInfo; element(i), element(mod(i,3)+1)];
    end
end
mesh.noVert = size(mesh.vertices,1);

%Get Ids of edge middle
middleIds = [get_vert_id(new_vert(1,:),mesh,noOldVert); get_vert_id(new_vert(2,:),mesh,noOldVert); get_vert_id(new_vert(3,:),mesh,noOldVert)];


%New Edges
edges = zeros(9,2);
%halving existing edges
for i = 1:3
    newVertId = middleIds(i);
    VertIdA = get_vert_id(mesh.vertices(element(i),:),mesh,1);
    VertIdB = get_vert_id(mesh.vertices(element(mod(i,3)+1),:),mesh,1);
    
    edges(i*2-1,:) = [VertIdA, newVertId];
    edges(i*2,:) = [newVertId, VertIdB];
end
%inner edges
for i = 1:3
    newVertIdA = middleIds(i);
    newVertIdB = middleIds(mod(i,3)+1,:);
    edges(6+i,:) = [newVertIdA , newVertIdB];
end
%check new edges
for i= 1:9
    if get_edge_id(edges(i,:),mesh) == 0
        mesh.edges = [mesh.edges; edges(i,:)];
    end
end
mesh.noEdge = size(mesh.edges,1);

%new Elements

new_elements = [element(1), middleIds(1), middleIds(3);
                element(2), middleIds(2), middleIds(1);
                element(3), middleIds(3), middleIds(2);
                middleIds(1), middleIds(2), middleIds(3)];
mesh.elements = [mesh.elements; new_elements];
mesh.noElem = size(mesh.elements,1);
end

