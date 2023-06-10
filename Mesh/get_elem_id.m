function [index] = get_elem_id(elem,mesh)
%returns the Id of element in mesh. If element doesn't exist, then it returns the
%index 0

noElem = size(mesh.elements,1);

index = 0;
for i=1:noEdge
    if (mesh.elements(i,1) == elem(1) && mesh.elements(i,2) == elem(2) && mesh.elements(i,3) == elem(3) ) || ... 
       (mesh.elements(i,1) == elem(1) && mesh.elements(i,2) == elem(3) && mesh.elements(i,3) == elem(2) ) || ... 
       (mesh.elements(i,1) == elem(2) && mesh.elements(i,2) == elem(1) && mesh.elements(i,3) == elem(3) ) || ... 
       (mesh.elements(i,1) == elem(2) && mesh.elements(i,2) == elem(3) && mesh.elements(i,3) == elem(1) ) || ... 
       (mesh.elements(i,1) == elem(3) && mesh.elements(i,2) == elem(1) && mesh.elements(i,3) == elem(2) ) || ... 
       (mesh.elements(i,1) == elem(3) && mesh.elements(i,2) == elem(2) && mesh.elements(i,3) == elem(1) ) 
       
        index = i;
        break;
    end
end
end
