function bool = tol_check(x,y)
%checks if x == y with some toleranz.
% x == y +- tol

bool = 0;
tol = 10^(-6);

if abs(x-y) <= tol
    bool = 1;
end
end

