clear all

%Simple mesh for the unitsquare
mesh.vertices = [0  ,0;
                 1  ,0;
                 1  ,1;
                 0  ,1
                 0.5,0;
                 0.5,0;
                 1  ,0.5;
                 0.5,1;
                 0  ,0.5;
                 0.5,0.5];
            
mesh.edges = [1,5;
              6,2;
              2,7;
              7,3;
              3,8;
              8,4;
              4,9;
              9,1;
              1,10;
              2,10;
              3,10;
              4,10;
              5,10;
              6,10;
              7,10;
              8,10;
              9,10];
              
mesh.elements = [1,5,10;
                 6,2,10;
                 2,7,10;
                 7,3,10;
                 3,8,10;
                 8,4,10;
                 4,9,10;
                 9,1,10];
             
%mesh.vertices = [0,0; 1,0; 1,1; 0,1];
%mesh.edges = [1,2;2,3;3,4;4,1];
%mesh.elements = [1,2,3;3,4,1];
        
mesh.noVert = size(mesh.vertices,1);
mesh.noEdge = size(mesh.edges,1);
mesh.noElem = size(mesh.elements,1);

mesh.name = 'Riss';
mesh.level = 0;

filepath = strcat('Mesh/Files/', mesh.name);
mkdir(filepath);
save(strcat(filepath, '/level0.mat'), '-struct', 'mesh');
