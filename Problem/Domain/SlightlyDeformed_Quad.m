%Simple mesh for the unitsquare
mesh.vertices = [0  ,0.02;
                 1  ,0;
                 1  ,1;
                 0  ,1
                 0.5,0.01;
                 1  ,0.5;
                 0.5,1;
                 0  ,0.5;
                 0.5,0.5];
            
mesh.edges = [1,5;
              5,2;
              2,6;
              6,3;
              3,7;
              7,4;
              4,8;
              8,1;
              1,9;
              2,9;
              3,9;
              4,9;
              5,9;
              6,9;
              7,9;
              8,9];
              
mesh.elements = [1,5,9;
                 5,2,9;
                 2,6,9;
                 6,3,9;
                 3,7,9;
                 7,4,9;
                 4,8,9;
                 8,1,9];
             
%mesh.vertices = [0,0; 1,0; 1,1; 0,1];
%mesh.edges = [1,2;2,3;3,4;4,1];
%mesh.elements = [1,2,3;3,4,1];
        
mesh.noVert = size(mesh.vertices,1);
mesh.noEdge = size(mesh.edges,1);
mesh.noElem = size(mesh.elements,1);

mesh.name = 'SlightlyDeformed_Quad';