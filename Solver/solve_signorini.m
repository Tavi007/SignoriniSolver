function [equilibriumConvergence, contactConvergence] = solve_signorini(setup, material, solverPara, outputPara)


%Input
domainName = setup.domainName;
obstacleName = setup.obstacleName;
forceName = setup.forceName;
volumeForce = setup.volumeForce;
level = solverPara.level;

%create Output folder
filepath = strcat('Output/', domainName, 'Domain/', obstacleName, 'Obstacle/', forceName, 'Force/');
switch solverPara.contactType
    case 'linear'
    filepathSolution = strcat(filepath, material.law, '/linC/');
    case 'non linear'
    filepathSolution = strcat(filepath, material.law, '/genC/');
    case 'linear normiert'
    filepathSolution = strcat(filepath, material.law, '/linC_Normed/');
end
mkdir(filepathSolution);

%save Log, if wanted
if outputPara.saveLog
  filename_log = strcat(filepathSolution, 'log_lvl' ,num2str(level),'.txt');
  delete(filename_log)
  diary(filename_log)
end

%Show choosen parameter in the log
disp(strcat('Domain:_______', domainName))
disp(strcat('Obstacle:_____', obstacleName))
disp(strcat('Force:________', forceName))
disp(strcat('Material:_____', material.name))
disp(strcat('Law:__________', material.law))
disp(strcat('Contact Type__:', num2str(solverPara.contactType)))
disp(strcat('Meshlevel:____', num2str(level)))


% ==================
% = Pre Processing =
% ==================
%load Problem
disp('Load Problem')
problem = load_problem(domainName, obstacleName, volumeForce, forceName, solverPara);

%Get Mesh
mesh = load(strcat('Mesh/Files/', domainName, '/level', num2str(level), '.mat'));
%Set Boundary Vertices
mesh = set_boundary(mesh, problem);
%plot_gammaC(mesh) %Helperfunction
%hilfsPlot(zeros(mesh.noVert*2,1), mesh, problem, 100)

%Set Material
if strcmp(material.law,'Linear elastisch')
    [material.sigma, material.Dsigma] = linearElastic(material.para); %functions for the first piola Kirschhoff stress tensor
elseif strcmp(material.law,'St.Venant')
    [material.sigma, material.Dsigma] = stVenant(material.para); %functions for the first piola Kirschhoff stress tensor
elseif strcmp(material.law,'Neo Hooke')
    [material.sigma, material.Dsigma] = neoHooke(material.para); %functions for the first piola Kirschhoff stress tensor
else
    error('Error: material not found')
end %room for more

disp('Preprocessing done.')
disp('================================')
disp('Start solver.')

% ==========
% = Solver =
% ==========
if mesh.noCVert ~= 0
    [u_sol, lambda_sol, equilibriumConvergence, contactConvergence] = solve_inequality(material,mesh,problem,solverPara);
else
    %no contact
    [u_sol, equilibriumConvergence] = newton(material,mesh,problem,solverPara);
    lambda_sol = 0;
    contactConvergence = equilibriumConvergence*NaN;
end

% ===================
% = Post Processing =
% ===================

if strcmp(problem.forceName, 'Special')
   L2error = compute_L2_error(u_sol, mesh);
   %H1error = sqrt(L2error^2 + compute_grad_L2_error(u_sol, mesh)^2);
   disp(strcat('L2-error:', num2str(L2error))) 
   %disp(strcat('H1-error:', num2str(H1error))) 
end

%save Ouptut
if outputPara.saveSolution
    writeVTK(filepathSolution, mesh, u_sol, lambda_sol, material, problem, solverPara)
    mkdir(strcat(filepathSolution, 'Saves/'));
    save(strcat(filepathSolution, 'Saves/u', num2str(level), '.mat'), 'u_sol');
    save(strcat(filepathSolution, 'Saves/ForceConv', num2str(level), '.mat'), 'equilibriumConvergence');
    if mesh.noCVert ~= 0 %With Contact
        mkdir(strcat(filepathSolution, 'Saves/'));
        save(strcat(filepathSolution, 'Saves/lmd', num2str(level), '.mat'), 'lambda_sol');
        save(strcat(filepathSolution, 'Saves/ContactConv', num2str(level), '.mat'), 'contactConvergence');
    end
end

%Plot solution
if outputPara.plotSigma
    plot_sigma(u_sol, material.sigma, mesh, problem);
    if mesh.noCVert ~= 0
        %plot_lambda(lambda_sol, mesh);
    end
end

disp('Simulation Done')
disp('=========================================')
diary off
end