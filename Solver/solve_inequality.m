function [u, lambda, equilibriumConvergence, contactConvergence] = solve_inequality(material,mesh,problem,solverPara)
%Solves the inequaltity A*u => rhs

noVert = mesh.noVert;
noCVert = mesh.noCVert;
CVertId = mesh.gammaCVertId;

%if possible, use interpolated values from coarse mesh
[u, lambda] = interpolate_coarse_solution(problem, mesh, solverPara, material);

%if material law is 'Linear elastisch' DuF is constant.
if strcmp('Linear elastisch', material.law)
    DuF = assembly_DuF(u,material,mesh);
end
%if contact is linear DuG is constant.
if strcmp('linear', solverPara.contactType) || strcmp('linear normiert', solverPara.contactType)
    DuG = assembly_DuG(u, lambda, mesh, problem, solverPara);
end

sameSets=false;
TOLReached=false;
solving=true;
noIter=0;
equilibriumConvergence = [];
contactConvergence = [];


[RHS_force, RHS_contact, set_A_local, set_I_local] = get_RHS(u, lambda,
                                                         material, mesh, problem, solverPara);
RHS = [RHS_force; RHS_contact];
RHS = include_bdr_conditions(RHS, mesh, problem);

residuum = norm(RHS);
residuum_force = norm(RHS_force);
residuum_contact = norm(RHS_contact);
equilibriumConvergence = [equilibriumConvergence; residuum_force];
contactConvergence = [contactConvergence; residuum_contact];
%Newton Loop
for loop = 1:solverPara.maxNewtonLoops 
    if residuum<solverPara.newtonTOL
        disp(strcat('RHS < TOL after ', num2str(noIter), ' Newton Iterations'))
        break; % solution has been found
    elseif residuum>1.0e+10
        disp(strcat('Divergenz nach ', num2str(noIter), ' Newton Iterationen eingetreten.'))
        break; % Divergenz
    end
    
    noIter=noIter+1;
    
    % Assembly Matrices
    if ~strcmp('Linear elastisch', material.law) %if linear elasitsch, DuF is constant and already computed
        DuF = assembly_DuF(u,material,mesh);
    end
    if ~(strcmp('linear', solverPara.contactType) || strcmp('linear normiert', solverPara.contactType)) %if linear contact, DuG is constant and already computed
        DuG = assembly_DuG(u, lambda, mesh, problem, solverPara);
    end
    DlG = assembly_DlG(u, mesh, problem, solverPara);
    dim_A = size(set_A_local,2);
    Du_dA = DlG(:,set_A_local)';
    Dl_dA = zeros(dim_A,mesh.noCVert);
    dim_I = size(set_I_local,2);
    Du_lmdI = zeros(dim_I,mesh.noVert*2);
    Dl_lmdI = zeros(dim_I,mesh.noCVert);
    for i = 1:dim_I
        for j = 1:mesh.noCVert
            if set_I_local(i) == j
                Dl_lmdI(i,j) = 1;
            end
        end
    end
    Matrix = sparse([DuF + DuG, DlG;
                    Du_dA,     Dl_dA;
                    Du_lmdI,   Dl_lmdI]);
    Matrix = include_bdr_conditions(Matrix, mesh, 0);
    
    %solve
    x = Matrix\RHS;
    residuum_LGS = norm(Matrix*x-RHS);
    delta_u = x(1:noVert*2);
    delta_lambda = x(noVert*2+1:length(x));
    
    if norm(x)<solverPara.newtonTOL
        u = u + delta_u;
        lambda = lambda + delta_lambda;
        disp(strcat('norm(x) < TOL after ', num2str(noIter), ' Newton Iterations'))
        break; % delta_u and delta_lambda got to small.
    end
    
    %Schrittweitenkontrolle
    alpha = 1;
    residuum_alt = residuum;
    while alpha > solverPara.alphaMin  
        u = u + alpha * delta_u;
        lambda = lambda + alpha * delta_lambda;
        
        [RHS_force, RHS_contact, set_A_local, set_I_local] = get_RHS(u, lambda,
                                                        material, mesh, problem, solverPara);
        RHS = [RHS_force; RHS_contact];
        RHS = include_bdr_conditions(RHS, mesh, problem);
        residuum = norm(RHS);
        
        if solverPara.strengeMonotonie
            if residuum < residuum_alt
                break;
            end
        else
            if residuum < (1 + 2*solverPara.delta*alpha + solverPara.delta*alpha*alpha)*residuum_alt
                break;
            end
        end
            
        u = u - alpha * delta_u;
        lambda = lambda - alpha * delta_lambda;
        alpha = alpha*solverPara.alphaScale;
    end
    equilibriumConvergence = [equilibriumConvergence; norm(RHS_force)];
    contactConvergence = [contactConvergence; norm(RHS_contact)];
    disp(strcat('residuum alt:', num2str(residuum_alt), ' | residuum neu:', num2str(residuum), ' | residuum LGS:', num2str(residuum_LGS) ))
    disp(strcat('Newtoniteration: ', num2str(noIter),' | alpha: ', num2str(alpha)))
    solver_log(set_A_local, set_I_local, norm(RHS_force), norm(RHS_contact)); 
    %hilfsPlot(u, mesh, problem, noIter+6)
end
disp('Done with solving')
end

function [RHS_force, RHS_contact, set_A_local,set_I_local] = get_RHS(u, lambda,
                                                             material, mesh, problem, solverPara)
    
    d_p = assembly_obstacle(u, mesh, problem, solverPara);
    [set_A_local,set_I_local] = get_complementary_sets(d_p, lambda, mesh, solverPara);  
    
    %Assembly force RHS
    F = assembly_F(u,material,mesh,problem);
    DlG = assembly_DlG(u, mesh, problem, solverPara);
    G = DlG * lambda;
    
    %Assembly contact RHS
    d_A = d_p(set_A_local); 
    lmdI = lambda(set_I_local);
    
    RHS_force = -(F + G);
    RHS_contact = -[d_A; lmdI];
    
end
