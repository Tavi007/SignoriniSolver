function problem = load_problem(domainName, obstacleName, volumeForce, forceName, solverPara)

problem = load_domain(domainName); 
problem = load_obstacle(problem, obstacleName, solverPara);
problem.force = volumeForce;
problem.forceName = forceName;
problem.domainName = domainName;
problem.obstacleName = obstacleName;
end

function problem = load_domain(domainName)
switch domainName  
    case 'Deformed_Quad'
        %Dirichlet Data
        problem.phiD = @(x) x(2) - 1;           %Describes Dirichlet boundary
        problem.dirichlet = @(x) 0;             %Dirichlet value is always 0
        %Contact Data
        problem.phiC = @(x) 0.25-0.25*x(1);               %Describes Contact boundary
        problem.gradPhiC = @(x) -0.25;               %Describes Contact boundary
        
    case 'Rechteck'
        %Dirichlet Data
        problem.phiD = @(x) x(2) - 3;           %Describes Dirichlet boundary
        problem.dirichlet = @(x) 0;             %Dirichlet value is always 0
        %Contact Data
        problem.phiC = @(x) 0;               %Describes Contact boundary
        problem.gradPhiC = @(x) 0;               %Describes Contact boundary
        
    otherwise 
        %Quad as default
        %Dirichlet Data
        problem.phiD = @(x) x(2) - 1;           %Describes Dirichlet boundary
        problem.dirichlet = @(x) 0;             %Dirichlet value is always 0
        %Contact Data
        problem.phiC = @(x) 0;               %Describes Contact boundary
        problem.gradPhiC = @(x) 0;               %Describes Contact boundary
end
end

function problem = load_obstacle(problem, obstacleName, solverPara)
problem.obstacleName = obstacleName; 
switch obstacleName
    case 'Platt'
        problem.obstacle = @(y) -0.15; 
        problem.gradObstacle = @(y) 0;
        problem.gradGradObstacle = @(y) 0; 
        problem.obstacle_minmax = [-0.2,1.2]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    case 'Linie'
        problem.obstacle = @(y) 0.4*y(1)-0.55; 
        problem.gradObstacle = @(y) 0.4;
        problem.gradGradObstacle = @(y) 0; 
        problem.obstacle_minmax = [0,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    case 'Parabel'
        problem.obstacle = @(y) -(y(1)-0.5)*(y(1)-0.5) -0.1; 
        problem.gradObstacle = @(y) -2*(y(1)-0.5);
        problem.gradGradObstacle = @(y) -2; 
        problem.obstacle_minmax = [0,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    case 'Spitze'
        problem.obstacle = @(y) -1*abs(y(1) - 0.5)-0.1; 
        problem.gradObstacle = @(y) gradSpike(y);
        problem.gradGradObstacle = @(y) 0; 
        problem.obstacle_minmax = [0,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    case 'Hut'
        problem.obstacle = @(y) funkHat(y); 
        problem.gradObstacle = @(y) 0;
        problem.gradGradObstacle = @(y) 0; 
        problem.obstacle_minmax = [0,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    case 'Special'
        [u1, u2] = get_special_solution();
        [dxU1, dyU1, dxU2, dyU2] = get_special_gradSolution();
        [dxxU1, dxyU1, dyyU1, dxxU2, dxyU2, dyyU2] = get_special_gradGradSolution();
    
        problem.obstacle = @(y) u2([y,0]); 
        problem.gradObstacle = @(y) dxU2([y,0]);
        problem.gradGradObstacle = @(y) dxxU2([y,0]); 
        problem.obstacle_minmax = [-1,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
        
    otherwise
        % No Obstalce as default
        problem.obstacleName = 'None';  
        problem.obstacle = @(y) -100000; 
        problem.gradObstacle = @(y) 0;
        problem.gradGradObstacle = @(y) 0; 
        problem.obstacle_minmax = [0,1]; %for plotting the obstacle in octave
        problem = get_gapfunctions(problem,solverPara);
    end
end

function value = gradSpike(y)
    if y(1) < 0.5
        value = 1;
    else
        value = -1;
    end
end

function value = funkHat(y)
    if y(1) >= 0.25 && y(1) <= 0.75 
        value = -0.1;
    else
        value = -0.4;
    end
end