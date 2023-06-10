function [u1, u2] = get_special_solution()
    u1 = @(x) get_special_solution_1(x);
    u2 = @(x) get_special_solution_2(x);
endfunction

function value = get_special_solution_1(x)
    zwsp_m = x(1)-1/2;
    zwsp_p = x(1)+1/2;
    if abs(x(1)) < 0.5
        value = 27/pi*sin(4*pi/3*(3-x(2))) * (zwsp_m^3*zwsp_p^4 + zwsp_m^4*zwsp_p^3);
    else
        value = 0;
    end
endfunction

function value = get_special_solution_2(x)
    zwsp_m = x(1)-x(2)^2/18-0.5;
    zwsp_p = x(1)+x(2)^2/18+0.5;
    if abs(x(1)) < x(2)^2/18+1/2
        value = (x(2)-3)^2*zwsp_m^4*zwsp_p^4;
    else
        value = 0;
    end
endfunction
