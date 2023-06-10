function [sigma_R, Dsigma_R] = linearElastic(matPara)
%returns the stress function (linear elastic) and its derivatives. 
%These function depend on u (on one Elemen!) and (v,w)

sigma_R = @(gradU) linearSigma_R(gradU,matPara);
Dsigma_R = @(gradU,gradV) linearDSigma_R(gradU,gradV,matPara);
end

function sigma_R = linearSigma_R(gradU,matPara)
[E, ~] = strainLinear();
E_u = E(gradU);
sigma_R = sparse(matPara.lambda*trace(E_u)*eye(3) + 2*matPara.mu*E_u);
end

function Dsigma_R = linearDSigma_R(gradU,gradV,matPara)
[~, DE] = strainLinear();
DE_uv = DE(gradU,gradV);
Dsigma_R = sparse(matPara.lambda*trace(DE_uv)*eye(3) + 2*matPara.mu*DE_uv);
end
