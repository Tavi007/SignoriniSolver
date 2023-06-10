function [du1_dx, du1_dy, du2_dx, du2_dy] = get_special_gradSolution()
    
    du1_dx = @(x) special_solution_1_dx(x);
    du1_dy = @(x) special_solution_1_dy(x);
    du2_dx = @(x) special_solution_2_dx(x);
    du2_dy = @(x) special_solution_2_dy(x);
 
endfunction

function value = special_solution_1_dx(x)
    if abs(x(1)) < 0.5
        zwsp_m = x(1)-1/2;
        zwsp_p = x(1)+1/2;
        value = 27/pi*sin(4*pi/3*(3-x(2))) * (3*zwsp_m^2*zwsp_p^4 + 4*zwsp_m^3*zwsp_p^3 ...
                                            + 4*zwsp_m^3*zwsp_p^3 + 3*zwsp_m^4*zwsp_p^2);
    else
        value = 0;
    end
endfunction

function value = special_solution_1_dy(x)
    if abs(x(1)) < 0.5
        zwsp_m = x(1)-1/2;
        zwsp_p = x(1)+1/2;
        value = -36*cos(4*pi/3*(3-x(2))) * (zwsp_m^3*zwsp_p^4 + zwsp_m^4*zwsp_p^3);
    else
        value = 0;
    end
endfunction

function value = special_solution_2_dx(x)
    if abs(x(1)) < x(2)^2/18+1/2
        zwsp_m = x(1)-x(2)^2/18-0.5;
        zwsp_p = x(1)+x(2)^2/18+0.5;
        value = (x(2)-3)^2*(4*zwsp_m^3*zwsp_p^4 + 4*zwsp_m^4*zwsp_p^3);
    else
        value = 0;
    end
endfunction

function value = special_solution_2_dy(x)
    if abs(x(1)) < x(2)^2/18+1/2
        zwsp_m = x(1)-x(2)^2/18-0.5;
        zwsp_p = x(1)+x(2)^2/18+0.5;
        value = 2*(x(2)-3) * zwsp_m^4 * zwsp_p^4 ...
              + (x(2)-3)^2 * 4*zwsp_m^3*(-x(2)/9) * zwsp_p^4 ...
              + (x(2)-3)^2 * zwsp_m^4 * 4*zwsp_p^3*x(2)/9;
    else
        value = 0;
    end
endfunction
