function [sigma_R, Dsigma_R] = stVenant(matPara)
%returns the stress function (linear elastic) and its derivatives. 
%These function depend on u (on one Elemen!) and (v,w)

sigma_R = @(gradU) stVenantSigma_R(gradU,matPara);
Dsigma_R = @(gradU,gradV) stVenantDSigma_R(gradU,gradV,matPara);
end

function sigma_R = stVenantSigma_R(gradU,matPara)
[E, ~] = strain();
E_u = E(gradU);
Sigma = matPara.lambda*trace(E_u)*eye(3) + 2*matPara.mu*E_u;

%Transform the second piola tensor to the first.
sigma_R = (eye(3)+gradU) * Sigma;

% Tests
%sigma_R = Sigma; %ohne Produktregel
%sigma_R = E_u; %nur Verzerrungstensor
%sigma_R = gradU + gradU' + gradU'*gradU;
end

function Dsigma_R = stVenantDSigma_R(gradU,gradV,matPara)
[E, DE] = strain();
DE_uv = DE(gradU,gradV);
E_u = E(gradU);

gradPhiU_inv = inv(eye(3)+gradU);
 
Sigma  = matPara.lambda*trace(E_u)*eye(3)   + 2*matPara.mu*E_u;
DSigma = matPara.lambda*trace(DE_uv)*eye(3) + 2*matPara.mu*DE_uv;

Dsigma_R = gradV*Sigma + (eye(3)+gradU)*DSigma;

%Tests
%Dsigma_R = DSigma; %ohne Produktregel
%Dsigma_R = DE_uv; % nur Verzerrungstensor
%Dsigma_R = gradV + gradV' + gradV'*gradU + gradU'*gradV;
end