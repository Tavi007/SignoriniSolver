function [dxxU1_ana, dxyU1_ana, dyyU1_ana, dxxU2_ana, dxyU2_ana, dyyU2_ana] = get_special_gradGradSolution()
    dxxU1_ana = @(x) analytical_dxxU1(x);
    dxyU1_ana = @(x) analytical_dxyU1(x);
    dyyU1_ana = @(x) analytical_dyyU1(x);
    
    dxxU2_ana = @(x) analytical_dxxU2(x);
    dxyU2_ana = @(x) analytical_dxyU2(x);
    dyyU2_ana = @(x) analytical_dyyU2(x);
    
endfunction

function value = analytical_dxxU1(x)
    if abs(x(1)) < 0.5
        zwsp_m = x(1)-1/2;
        zwsp_p = x(1)+1/2;
        value = 27/pi*sin(4*pi/3*(3-x(2))) ...
                        * (6*zwsp_m  *zwsp_p^4 ...
                        + 36*zwsp_m^2*zwsp_p^3 ...
                        + 36*zwsp_m^3*zwsp_p^2 ...
                        +  6*zwsp_m^4*zwsp_p);
    else
       value = 0;
    end
end

function value = analytical_dxyU1(x)
    if abs(x(1)) < 0.5
        zwsp_m = x(1)-1/2;
        zwsp_p = x(1)+1/2;
        value = -36*cos(4*pi/3*(3-x(2))) ...
                    * (3*zwsp_m^2*zwsp_p^4 ...
                    +  8*zwsp_m^3*zwsp_p^3 ...
                    +  3*zwsp_m^4*zwsp_p^2);
    else
       value = 0;
    end
end

function value = analytical_dyyU1(x)
    if abs(x(1)) < 0.5
        zwsp_m = x(1)-1/2;
        zwsp_p = x(1)+1/2;
        value = -48*pi*sin(4*pi/3*(3-x(2))) ...
                        * (zwsp_m^3*zwsp_p^4 ...
                        +  zwsp_m^4*zwsp_p^3);
    else
       value = 0;
    end
end
    

function value = analytical_dxxU2(x)
    if abs(x(1)) < x(2)^2/18+1/2
        zwsp_m = x(1)-x(2)^2/18-1/2;
        zwsp_p = x(1)+x(2)^2/18+1/2;
        value = (x(2)-3)^2 ...
                    * (12*zwsp_m^2*zwsp_p^4 ...
                    +  32*zwsp_m^3*zwsp_p^3 ...
                    +  12*zwsp_m^4*zwsp_p^2);
    else
       value = 0;
    end
end

function value = analytical_dxyU2(x)
    if abs(x(1)) < x(2)^2/18+1/2
        zwsp_m = x(1)-x(2)^2/18-1/2;
        zwsp_p = x(1)+x(2)^2/18+1/2;
        value = 2*(x(2)-3) ...
                    * (4*zwsp_m^3*zwsp_p^4 ...
                    +  4*zwsp_m^4*zwsp_p^3) ...
           + (x(2)-3)^2 ...
                    * (-12*x(2)/9*zwsp_m^2*zwsp_p^4 ...
                    +   12*x(2)/9*zwsp_m^4*zwsp_p^2);
    else
       value = 0;
    end
end

function value = analytical_dyyU2(x)
    if abs(x(1)) < x(2)^2/18+1/2
        zwsp_m = x(1)-x(2)^2/18-1/2;
        zwsp_p = x(1)+x(2)^2/18+1/2;
        value = 2*zwsp_m^4*zwsp_p^4 ...
              + 16/9*(x(2)-3)*x(2) * (zwsp_m^4*zwsp_p^3 - zwsp_m^3*zwsp_p^4) ...
              +  4/9*(x(2)-3)^2    * (zwsp_m^4*zwsp_p^3 - zwsp_m^3*zwsp_p^4) ...
              +  4/9*(x(2)-3)^2*x(2) * (x(2)/3*zwsp_m^4*zwsp_p^2 + x(2)/3*zwsp_m^2*zwsp_p^4 - 8/9*x(2)*zwsp_m^3*zwsp_p^3);
    else
       value = 0;
    end
end
    
