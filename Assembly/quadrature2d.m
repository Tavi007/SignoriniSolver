function value = quadrature2d(integrand,order)
%Computes the Quadrature of the integrand on the reference triangle
% conv{(0,0), (1,0), (0,1)} with choosen order

if order < 1 || order > 4
    error('Choosen quadrature order not implemented');
end
switch order
    case 1
        coordinates = [0, 0;
                       1, 0;
                       0, 1];
        weigths = [1;1;1]/6;
    case 2
        coordinates = [0.5, 0;
                       0, 0.5;
                       0.5, 0.5];
        weigths = [1;1;1]/6;
    case 3
        coordinates = [0, 0;
                       1, 0;
                       0, 1
                       0, 0.5;
                       0.5, 0;
                       0.5, 0.5;
                       1/3, 1/3];
         weigths = [3;3;3;8;8;8;27]/120;       
    case 4
        coordinates = [0.063089014491502, 0.063089014491502;
                       0.873821971016996, 0.063089014491502;
                       0.063089014491502, 0.873821971016996;
                       0.24928674517091, 0.24928674517091;
                       0.501426509658179, 0.24928674517091;
                       0.24928674517091, 0.501426509658179;
                       0.310352451033785, 0.053145049844816;
                       0.636502499121399, 0.310352451033785;
                       0.053145049844816, 0.636502499121399;
                       0.636502499121399, 0.053145049844816;
                       0.310352451033785, 0.636502499121399;
                       0.053145049844816, 0.310352451033785];
                       # weights
         weigths = [0.0254224531851035;
                    0.0254224531851035;
                    0.0254224531851035;
                    0.0583931378631895;
                    0.0583931378631895;
                    0.0583931378631895;
                    0.041425537809187;
                    0.041425537809187;
                    0.041425537809187;
                    0.041425537809187;
                    0.041425537809187;
                    0.041425537809187];
end

%Sum
value=0;
for i = 1:size(weigths,1)
    integrand_val = integrand(coordinates(i,:));
    value = value + integrand_val * weigths(i);
end

end

