function [index] = get_vert_id(vertex,mesh, startId)
%returns the Id of vertex in mesh. If vertex doesn't exist, then it returns the
%index 0
noVert = mesh.noVert;

index = 0;
for i=startId:noVert
    if tol_check(mesh.vertices(i,1),vertex(1)) && tol_check(mesh.vertices(i,2),vertex(2)) 
        index = i;
        break;
    end
end
end

