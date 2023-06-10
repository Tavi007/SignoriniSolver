function [u_sol, equilibriumConvergence] = newton(material,mesh,problem,solverPara)
%Finds the solution of F(u)(v) = 0 \forall v

%if possible, use interpolated values from coarse mesh
%[u_new, lambda_new, activeSet_new, inactiveSet_new] = interpolate_old_solution(problem, mesh)
u = zeros(mesh.noVert*2,1);

% Newton Loop
RHS = -assembly_F(u,material,mesh,problem);
residuum = norm(RHS);
equilibriumConvergence = [];
noIter = 0;
while residuum > solverPara.newtonTOL
    equilibriumConvergence = [equilibriumConvergence; residuum];
    Matrix = assembly_DuF(u,material,mesh);
    Matrix = include_bdr_conditions(Matrix, mesh, 0);
    
    delta_u = Matrix\RHS;
    u = u + delta_u;
    
    RHS = -assembly_F(u,material,mesh,problem);
    residuum = norm(RHS);
    if noIter > solverPara.maxNewtonLoops
        disp('Max Iteration reached')
        break;
    end
    
    disp(['F(u)(v) = ', num2str(residuum)]);
    noIter = noIter + 1;
end
u_sol = u;
equilibriumConvergence = [equilibriumConvergence; residuum];
disp('Newton done')
end

