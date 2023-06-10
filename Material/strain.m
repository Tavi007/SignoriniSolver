function [E, DE] = strain()
%returns the strain function and its derivatives. 
%These function depend on u (on one Elemen!) and (v,w)

E = @(gradU) StrainE(gradU);
DE = @(gradU,gradV) StrainDE(gradU,gradV);
end

function E = StrainE(gradU)
E = ( gradU + gradU' + gradU'*gradU )/2;
end

function DE = StrainDE(gradU,gradV)
%DE = ( (eye(3) + gradU')*gradV + gradV'*(eye(3)+gradU) )/2;
DE = ( gradV + gradV' + gradV'*gradU + gradU'*gradV )/2;
end

