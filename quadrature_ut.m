% By Thomas Helmich
clc;
pkg load miscellaneous;
%clear functions;
%clear variables;
addpath('MathTools', 'Mesh', 'Assembly', 'Material', 'Problem');

level_min = 0;
level_max = 3;

f_list = {@(x) 1, @(x) x(1), @(x) x(2), @(x) x(1)^2};
integral_value_list = {1, 1/2, 1/2, 1/3};

solverPara.linearContact = 1;
problem = load_problem('Quad', 'None', @(x) 0, 'Special', solverPara);

for lvl = level_min:level_max
    mesh = load(strcat('Mesh/Files/Quad/level',num2str(lvl),'.mat'));
    mesh = set_boundary(mesh, problem);
    
    for f_index = 1:4
        f = f_list{f_index};
        Integral_value = integral_value_list{f_index};
        
        for order = 1:4
            Integral_value_quad = 0;
            for e = 1:mesh.noElem 
                element = mesh.elements(e,:);
                a1 = mesh.vertices(element(1),:)';
                a2 = mesh.vertices(element(2),:)';
                a3 = mesh.vertices(element(3),:)';
                DTrafo = [[a2-a1, a3-a1], [0;0];
                          [0,0]         , 1]; % x = DTrafo*x_hat + d
                DTrafo_inv_T = (inv(DTrafo))';
                TrafoDet = det(DTrafo);
                
                f_hat = @(x_hat) f(trafo_from_ref_2d(x_hat,element,mesh)) * TrafoDet;
                Integral_value_quad = Integral_value_quad + quadrature2d(f_hat,order);
            end
            
            if abs(Integral_value_quad-Integral_value) < 1e-4
                disp(strcat('Order:', num2str(order),' with force ', num2str(f_index), ' is correct'))
            else
                disp(strcat('Order:', num2str(order),' with force ', num2str(f_index), ' is wrong')) 
            end
            disp([Integral_value, Integral_value_quad])
        end
        disp('-------------------')
    end
end
