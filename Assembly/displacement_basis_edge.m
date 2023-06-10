function Basis = displacement_basis_edge(index,grad_bool)
%Evaluates a choosen Basisfunction in x. The Basis is for
%the reference Intervall [-1,1] and is 2-dimensional.
%grad_bool decides, if gradient or not.
if grad_bool == 0
    switch index
        case 1
            Basis = @(s_hat) [1-s_hat;0]/2;
        case 2
            Basis = @(s_hat) [1+s_hat;0]/2;
        case 3
            Basis = @(s_hat) [0;1-s_hat]/2;
        case 4
            Basis = @(s_hat) [0;1+s_hat]/2;
    end
elseif grad_bool == 1
    error('basis_edge: you should not be here')
else
    error('Wrong differential')
end
end