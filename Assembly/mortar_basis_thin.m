function Basis = mortar_basis_thin(index)
%Return a function handle for the choosen basis. The basis is for
%the reference Intervall [-1,1] -> R^1
%grad_bool decides if Gradient or not is returned

switch index
    case 1
        Basis = @(s_hat) thin_mortar_basis1(s_hat);
    case 2
        Basis = @(s_hat) thin_mortar_basis2(s_hat);
    case 3
        Basis = @(s_hat) thin_mortar_basis3(s_hat);
end
end

function value = thin_mortar_basis1(s_hat)
if s_hat < 0
    value = -1-3*s_hat;
else
    value = 0;
end
endfunction

function value = thin_mortar_basis2(s_hat)
if s_hat < 0
    value = 2+3*s_hat;
else
    value = 2-3*s_hat;
end
endfunction

function value = thin_mortar_basis3(s_hat)
if s_hat < 0
    value = 0;
else
    value = -1+3*s_hat;
end
endfunction