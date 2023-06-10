function value = quadrature1d(integrand,order)
%Computes the Quadrature of the integrand on the reference 
%Intervall [-1,1] with choosen order

if order < 1 || order > 3
    error('Choosen quadrature order not implemented');
end
switch order
    case 1
        coordinates = [0];
        weigths = [2];
    case 2
        coordinates = [-1; 1] *sqrt(1/3);
        weigths = [1; 1];
    case 3
        coordinates = [-1;0;1]*sqrt(3/5);
         weigths = [5;8;5]/9;       
    case 4
        coordinates = [-sqrt(3/7 + 2/7*sqrt(6/5));
                       -sqrt(3/7 - 2/7*sqrt(6/5));
                        sqrt(3/7 - 2/7*sqrt(6/5));
                        sqrt(3/7 + 2/7*sqrt(6/5));];
         weigths = [(18 - sqrt(30))/36;
                    (18 + sqrt(30))/36;
                    (18 + sqrt(30))/36;
                    (18 - sqrt(30))/36];          
end

%Sum
value=0;
for i = 1:size(weigths,1)
    integrand_val = integrand(coordinates(i,:));
    value = value + integrand_val * weigths(i);
end

end