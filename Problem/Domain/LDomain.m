%Simple mesh for the L-Domain. WIP!
mesh.vertices = [0,0;
                 1,0;
                 1,1;
                 0,1];
             
mesh.edges = [1,2;
              2,3;
              3,4;
              4,1;
              1,3];
              
% clockwise counted
mesh.elements = [1,2,5;
                 5,3,4];
             
mesh.name = 'LDomain';