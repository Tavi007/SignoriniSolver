function value = get_special_force(x_real, material)
    lambda=material.para.lambda;
    mu=material.para.mu;
    
    %analytical differential of u
    [dxxU1_ana, dxyU1_ana, dyyU1_ana, dxxU2_ana, dxyU2_ana, dyyU2_ana] = get_special_gradGradSolution();
    
    %f = -div(sigma(grad u)) with the linear elastic material law
    value = -[lambda*(dxxU1_ana(x_real) + dxyU2_ana(x_real)) + mu*(2*dxxU1_ana(x_real) + dxyU2_ana(x_real) + dyyU1_ana(x_real));
              lambda*(dxyU1_ana(x_real) + dyyU2_ana(x_real)) + mu*(2*dyyU2_ana(x_real) + dxxU2_ana(x_real) + dxyU1_ana(x_real));
              0];     


##    %numerical differential (for testing)
##    [u_1, u_2] = get_special_solution();
##    h = 1e-2;
##    
##    dxU1_num = @(x) (u_1(x+[h,0]) - u_1(x-[h,0]))/2/h;
##    dyU1_num = @(x) (u_1(x+[0,h]) - u_1(x-[0,h]))/2/h;
##    dxxU1_num = @(x) (dxU1_num(x+[h,0]) - dxU1_num(x-[h,0]))/2/h;
##    dxyU1_num = @(x) (dxU1_num(x+[0,h]) - dxU1_num(x-[0,h]))/2/h;
##    dyyU1_num = @(x) (dyU1_num(x+[0,h]) - dyU1_num(x-[0,h]))/2/h;
##    
##    dxU2_num = @(x) (u_2(x+[h,0]) - u_2(x-[h,0]))/2/h;
##    dyU2_num = @(x) (u_2(x+[0,h]) - u_2(x-[0,h]))/2/h;
##    dxxU2_num = @(x) (dxU2_num(x+[h,0]) - dxU2_num(x-[h,0]))/2/h;
##    dxyU2_num = @(x) (dxU2_num(x+[0,h]) - dxU2_num(x-[0,h]))/2/h;
##    dyyU2_num = @(x) (dyU2_num(x+[0,h]) - dyU2_num(x-[0,h]))/2/h;  
##
##    epsilon = @(x) [dxU1_num(x), (dyU1_num(x)+dxU2_num(x))/2, 0;
##                    (dyU1_num(x)+dxU2_num(x))/2, dyU2_num(x), 0;
##                    0, 0, 0];
##                    
##    sigma = @(x) lambda*trace(epsilon(x))*eye(3) + 2*mu*epsilon(x);
##    dx_sigma1 = @(x) (sigma(x+[h,0]) - sigma(x-[h,0]))/2/h * [1;0;0];
##    dy_sigma2 = @(x) (sigma(x+[0,h]) - sigma(x-[0,h]))/2/h * [0;1;0];
##    volumeForce_num = @(x) - dx_sigma1(x) - dy_sigma2(x);
endfunction
