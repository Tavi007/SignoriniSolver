% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('Assembly','Material','Material/Tools','MathTools','Mesh','Problem','Solver');

% ==============================
% = Problem & const Parameters =
% ==============================

%choose domain, force and obstacle
%setup.domainName = 'Rechteck';          % Quad, Deformed_Quad, LDomain, 
setup.domainName = 'Quad';
%setup.domainName = 'Riss';

%obstacleNameList = {'Special'};        % None, Platt, Linie, Parabel, Spitze, Hut
obstacleNameList = {'Parabel'};        % None, Platt, Linie, Parabel, Spitze, Hut
%obstacleNameList = {'Spitze'};        % None, Platt, Linie, Parabel, Spitze, Hut
%obstacleNameList = {'Parabel'};        % None, Platt, Linie, Parabel, Spitze, Hut
%obstacleNameList = {'None'};        % None, Platt, Linie, Parabel, Spitze, Hut

%forceNameList = {'Special'};
%forceNameList = {10,15,20};
forceNameList = {20};

%set Material
material.name = 'steel';       % choose: rubber, steel
material = materialConstants(material);
%materialLawList = {'Linear elastisch'}; 
materialLawList = {'St.Venant'}; 
%materialLawList = {'Neo Hooke'}; 
%materialLawList = {'Linear elastisch', 'Neo Hooke','St.Venant'}; % choose: Linear elastisch, St.Venant, Neo Hooke

%solver Parameters
level_min = 4;
level_max = 4;

%contactTypeList = {'linear'};
%contactTypeList = {'linear', 'non linear'};
contactTypeList = {'non linear'};
%contactTypeList = {'linear', 'non linear', 'linear normiert'};

solverPara.newtonTOL = 10^-10;       %TOL for Newton-Raphson
solverPara.maxNewtonLoops = 100;

%standard solver parameters
solverPara.scaleComplementary = 1; %the factor c from the complementary equation
solverPara.strengeMonotonie=false;
solverPara.alphaMin = 0.01;
solverPara.alphaScale = 1/2;
solverPara.delta = 0.04;

%testing other solver parameters
%solverPara.scaleComplementary = 1; %the factor c from the complementary equation
%solverPara.alphaMin = 0.01;
%solverPara.alphaScale = 1/3;

%Post-processing
outputPara.saveLog = true;
outputPara.saveSolution = true; %.vtk-file
outputPara.plotSigma = false; %octave plot
outputPara.saveTable = true;

noMaterialsLaws = numel(materialLawList);
noContactTypes = numel(contactTypeList);
noObstacles = numel(obstacleNameList);
noForces = numel(forceNameList);
%loops for automatic solver_starting

for forceIndex = 1:noForces
  
    if isnumeric(forceNameList{forceIndex})
        setup.forceName = strcat('Constant', num2str(forceNameList{forceIndex}) );
        setup.volumeForce = @(x) [0;-forceNameList{forceIndex};0]; %must 3 dimensional. (with y value is upwards and x sideways)
    else
        setup.forceName = strcat('Special');
      
        E=10;
        nu=0.3;
        material.para.lambda = nu/(1-2*nu)/(1+nu)*E;
        material.para.mu = E/(2+2*nu);
      
        setup.volumeForce = @(x) get_special_force(x, material);
    end
    
    for obstalceNameIndex = 1:noObstacles
        setup.obstacleName = obstacleNameList{obstalceNameIndex};
        
        for level = level_min:level_max
            solverPara.level = level;
            
            materialIter = 1;
            Table = cell(2,noMaterialsLaws);
            for materialLawIndex = 1:noMaterialsLaws    
                contactIter = 1;
                for contactTypeIndex = 1:noContactTypes
                    
                    %set values
                    material.law = materialLawList{materialLawIndex}; 
                    solverPara.contactType = contactTypeList{contactTypeIndex};
                    
                    %run solver
                    [equilibriumConvergence, contactConvergence] = solve_signorini(setup, material, solverPara, outputPara);
                    
                    %Fill Table
                    Table{materialIter,contactIter} = [equilibriumConvergence, contactConvergence];
                    contactIter = contactIter +1;
                end
                materialIter = materialIter +1;
            end
            
            Table = filterTable(Table);
            
            if outputPara.saveTable
                mesh = load(strcat('Mesh/Files/', setup.domainName, '/level', num2str(solverPara.level), '.mat'));
                TableFilePath = strcat('Output/TablesAndPlots/',setup.forceName,'/');
                mkdir(TableFilePath);
                writeTable(TableFilePath, Table, setup.obstacleName, mesh, contactTypeList, materialLawList);
            end
            
        end
        
    end
end
