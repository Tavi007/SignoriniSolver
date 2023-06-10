function [index] = get_edge_id(edge,mesh)
%returns the Id of edge in mesh. If edge doesn't exist, then it returns the
%index 0

noEdge = size(mesh.edges,1);

index = 0;
for i=1:noEdge
    if (mesh.edges(i,1) == edge(1) && mesh.edges(i,2) == edge(2)) || ... 
       (mesh.edges(i,1) == edge(2) && mesh.edges(i,2) == edge(1))
        index = i;
        break;
    end
end
end