function [u_new, lambda_new] = interpolate_coarse_solution(problem, mesh, solverPara, material)
    
    level = mesh.level;
    level_coarse = level-1;
    lambda_new = [];
    if level ~= 0
        %load coarse mesh and values
        mesh_coarse = load(strcat('Mesh/Files/', problem.domainName, '/level', num2str(level_coarse), '.mat'));
        mesh_coarse = set_boundary(mesh_coarse, problem);
        filepath = strcat('Output/', problem.domainName, 'Domain/', problem.obstacleName, 'Obstacle/', problem.forceName, 'Force/');
        switch solverPara.contactType
        case 'linear'
            filepathSolution = strcat(filepath, material.law, '/linC/');
        case 'non linear'
            filepathSolution = strcat(filepath, material.law, '/genC/');
        case 'linear normiert'
            filepathSolution = strcat(filepath, material.law, '/linC_Normed/');
        end
        
        %compute interpolated values
        u_coarse = load(strcat(filepathSolution, 'Saves/u', num2str(level_coarse), '.mat')).u_sol;
        u_x_coarse = u_coarse(1:mesh_coarse.noVert);
        u_y_coarse = u_coarse(mesh_coarse.noVert+1:mesh_coarse.noVert*2);
        u_x_interpol = [];
        u_y_interpol = [];
        noNewVertInfo = size(mesh.newVertInfo,1);
        for i = 1:noNewVertInfo
            vertIdA = mesh.newVertInfo(i,1);
            vertIdB = mesh.newVertInfo(i,2);
            u_x_interpol = [u_x_interpol; (u_x_coarse(vertIdA) + u_x_coarse(vertIdB) )/2 ];
            u_y_interpol = [u_y_interpol; (u_y_coarse(vertIdA) + u_y_coarse(vertIdB) )/2 ];
        end
        u_new = [u_x_coarse; u_x_interpol; u_y_coarse; u_y_interpol];
        
        if mesh_coarse.noCVert ~= 0
            %with contact
            
            lambda_coarse = load(strcat(filepathSolution, 'Saves/lmd', num2str(level_coarse), '.mat')).lambda_sol;
            [projectionMatrix, projectionVector] = assembly_projection(lambda_coarse, mesh_coarse, mesh);
            lambda_new = projectionMatrix\projectionVector;
            %lambda_new = zeros(mesh.noCVert,1);
        end
    else
        u_new = zeros(mesh.noVert*2,1);
        if mesh.noCVert ~= 0
            lambda_new = zeros(mesh.noCVert,1);
        end
    end
end
