%clc;
%clear all;
addpath('../Problem','../Problem/Domain', '../Mesh', '../MathTools');
%choose Domain
mesh.name = 'Rechteck';

%choose Level
level = 1;

%Refine Mesh
if level > 0
    mesh = load(strcat('../Mesh/Files/', mesh.name, '/level', num2str(level-1), '.mat'));
    mesh = refine_mesh(mesh);
end
disp('Done with meshing.')
mesh.level = level;

%Save mesh in file
filepath = strcat('../Mesh/Files/', mesh.name);
mkdir(filepath);
save(strcat(filepath, '/level', num2str(level), '.mat'), '-struct', 'mesh');