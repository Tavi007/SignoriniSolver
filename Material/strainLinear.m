function [E, DE] = strainLinear()
%returns the (linear) strain function and its derivatives. 
%These function depend on u (on one Elemen!) and (v,w)

E = @(gradU) StrainLinearE(gradU);
DE = @(gradU,gradV) StrainLinearDE(gradU,gradV);
end

function E = StrainLinearE(gradU)
E = (gradU + gradU')/2;
end

function DE = StrainLinearDE(gradU,gradV)
DE = (gradV + gradV')/2;
end
