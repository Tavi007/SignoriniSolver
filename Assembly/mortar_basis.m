function Basis = mortar_basis(index,grad_bool)
%Return a function handle for the choosen basis. The basis is for
%the reference Intervall [-1,1] -> R^1
%grad_bool decides if Gradient or not is returned

if grad_bool == 0
    switch index
        case 1
            Basis = @(s_hat) (1-3*s_hat)/2;
        case 2
            Basis = @(s_hat) (1+3*s_hat)/2;
    end
elseif grad_bool == 1
    switch index
        case 1
            Basis = @(s_hat) -3/2;
        case 2
            Basis = @(s_hat) +3/2;
    end
else
    error('Wrong differential')
end
end