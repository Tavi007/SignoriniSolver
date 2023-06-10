%Simple mesh for the unitsquare
mesh.vertices = [-1, 0;
                  0, 0;
                  1, 0;
                 -1, 1;
                  0, 1;
                  1, 1;
                 -1, 2;
                  0, 2;
                  1, 2;
                 -1, 3;
                  0, 3;
                  1, 3];
            
mesh.edges = [1, 2;
              2, 3;
              1, 4;
              2, 4;
              2, 5;
              3, 5;
              3, 6;
              4, 5;
              5, 6;
              4, 7;
              5, 7;
              5, 8;
              6, 8;
              6, 9;
              7, 8;
              8, 9;
              7, 10;
              8, 10;
              8, 11;
              9, 11;
              9, 12;
              10, 11;
              11, 12];
              
mesh.elements = [1, 2, 4;
                 2, 5, 4;
                 2, 3, 5;
                 3, 6, 5;
                 4, 5, 7;
                 5, 8, 7;
                 5, 6, 8;
                 6, 9, 8;
                 7, 8, 10;
                 8, 11, 10;
                 8, 9, 11;
                 9, 12, 11;];
        
mesh.noVert = size(mesh.vertices,1);
mesh.noEdge = size(mesh.edges,1);
mesh.noElem = size(mesh.elements,1);
mesh.level = 0;
mesh.name = 'Rechteck';

filepath = strcat('Mesh/Files/', mesh.name);
mkdir(filepath);
save(strcat(filepath, '/level0.mat'), '-struct', 'mesh');