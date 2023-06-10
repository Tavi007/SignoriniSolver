function [sigma_R, Dsigma_R] = neoHooke(matPara)
%returns the stress function (linear elastic) and its derivatives. 
%These function depend on u (on one Elemen!) and (v,w)

sigma_R = @(gradU) neoHookeSigma_R(gradU,matPara);
Dsigma_R = @(gradU,gradV) neoHookeDSigma_R(gradU,gradV,matPara);
end

function sigma_R = neoHookeSigma_R(gradU,matPara)
[E, ~] = strain();
E_u = E(gradU);
C = eye(3) + 2*E_u;
C_inv = inv(C);

mu = matPara.mu;
lambda = matPara.lambda;

Sigma = mu*eye(3) - (mu+lambda/2)*C_inv + lambda/2*det(C)*C_inv;

%Transform the second piola tensor to the first.
sigma_R = (eye(3)+gradU) * Sigma;
end

function Dsigma_R = neoHookeDSigma_R(gradU,gradV,matPara)
[E, DE] = strain();
DE_uv = DE(gradU,gradV);
E_u = E(gradU);

C = eye(3) + 2*E_u;
DC = 2*DE_uv;
C_inv = inv(C);
det_C = det(C);

mu = matPara.mu;
lambda = matPara.lambda;

Sigma  =  mu*eye(3) - (mu+lambda/2)*C_inv + lambda/2*det_C*C_inv;
DSigma = (mu+lambda/2)*C_inv*DC*C_inv + lambda/2*(det_C*T2_colon_T2(C_inv, DC)*C_inv - det_C*C_inv*DC*C_inv);

Dsigma_R = gradV*Sigma + (eye(3)+gradU)*DSigma;
end