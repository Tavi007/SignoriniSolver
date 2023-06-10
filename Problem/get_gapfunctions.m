function problem = get_gapfunctions(problem,solverPara)
%defines the gap-function with the obstacle- and gammaC-function.
%returns the problem now with gap-function and its derivatives depending on x and u

problem.gap = @(x,u) -get_gap(x,u, problem, solverPara);
problem.gradGap = @(x,u,v) -get_gradGap(x,u,v, problem,solverPara);
problem.gradGradGap = @(x,u,v,w) -get_gradGradGap(x,u,v,w, problem.gradGradObstacle,solverPara);
end

function gap = get_gap(x,u, problem, solverPara)
switch solverPara.contactType
    case 'linear'
    func_o = problem.obstacle(x);
    func_g = problem.phiC(x);
    n = [problem.gradObstacle(x), -1];
    gap = func_o - func_g + n*u; 
    case 'non linear'
    func_o = problem.obstacle(x + u(1));
    func_g = problem.phiC(x) + u(2);
    gap = func_o - func_g;
    case 'linear normiert'
    func_o = problem.obstacle(x);
    func_g = problem.phiC(x);
    n = [0, -1];
    gap = (func_o - func_g + n*u)/norm(n);
end
end

function gradGap = get_gradGap(x,u,v, problem, solverPara)
switch solverPara.contactType
    case 'linear'
    n = [problem.gradObstacle(x), -1];
    gradGap = n*v; 
    case 'non linear'
    n = [problem.gradObstacle(x + u(1)), -1];
    gradGap = n*v;
    case 'linear normiert'
    n = [0, -1];
    gradGap = n*v/norm(n);
end
end

function gradGradGap = get_gradGradGap(x,u,v,w, func_gradGradObstacle, solverPara)
switch solverPara.contactType
    case 'linear'
    gradGradGap = 0;
    case 'non linear'
    func_gradGradO = func_gradGradObstacle(x + u(1));
    gradGradGap = func_gradGradO*v(1)*w(1);
    case 'linear normiert'
    gradGradGap = 0; 
end
end