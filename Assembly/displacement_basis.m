function Basis = displacement_basis(index,grad_bool)
%Evaluates a choosen Basisfunction in x. The Basis is for
%the reference triangle conv{(0,0), (1,0), (0,1)} and is 2-dimensional.
%grad_bool decides, if gradient or not.
if grad_bool == 0
    switch index
        case 1
            Basis = @(x) [1-x(:,1)-x(:,2);0;0];
        case 2
            Basis = @(x) [x(:,1);0;0];
        case 3
            Basis = @(x) [x(:,2);0;0];
        case 4
            Basis = @(x) [0;1-x(:,1)-x(:,2);0];
        case 5
            Basis = @(x) [0;x(:,1);0];
        case 6
            Basis = @(x) [0;x(:,2);0];
    end
elseif grad_bool == 1
    switch index
        case 1
            Basis = [[-1;-1;0],[0;0;0],[0;0;0]];
        case 2
            Basis = [[1;0;0],[0;0;0],[0;0;0]];
        case 3
            Basis = [[0;1;0],[0;0;0],[0;0;0]];
        case 4
            Basis = [[0;0;0],[-1;-1;0],[0;0;0]];
        case 5
            Basis = [[0;0;0],[1;0;0],[0;0;0]];
        case 6
            Basis = [[0;0;0],[0;1;0],[0;0;0]];
        case 7
            Basis = [displacement_basis(1,1), displacement_basis(2,1), ...
                     displacement_basis(3,1), displacement_basis(4,1), ...
                     displacement_basis(5,1), displacement_basis(6,1)];    
    end
else
    error('Wrong differential')
end
end
