%Simple mesh for one triangle
mesh.vertices = [-1,0;
                 1,0;
                 0,1];
             
mesh.edges = [1,2;
              2,3;
              1,3];
          
mesh.elements = [1,2,3];
mesh.elementsSize = [1];

mesh.noVert = size(mesh.vertices,1);
mesh.noEdge = size(mesh.edges,1);
mesh.noElem = size(mesh.elements,1);