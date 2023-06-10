function [DPi, DDPi] = deformationEnergy(Sigma,DSigma,DDSigma)
%returns the energy functions DPi(u)(v) and DDPi(u)(v,w) on one element!

[Strain, DStrain, DDStrain] = strain();

DPi = @(u,v,DTrafo) energyD(u,v,DTrafo, Sigma,DSigma, Strain,DStrain);
DDPi = @(u,v,w,DTrafo) energyDD(u,v,w,DTrafo, Sigma,DSigma,DDSigma, Strain,DStrain,DDStrain);
end

function DPi = energyD(u,v,DTrafo, Sigma,DSigma, Strain,DStrain)
%get \nabla u(x) & \nabla v(x)
gradU = zeros(3,3);
gradV = zeros(3,3);
for i=1:6
    gradBasis_i = displacement_basis(i,1); %gradBasis is constant on the referenz triangle
    
    gradU = gradU + u(i)*gradBasis_i([0,0]);
    gradV = gradV + v(i)*gradBasis_i([0,0]);
end

TrafoU = DTrafo*gradU; 
TrafoV = DTrafo*gradV;
TrafoDet = abs(det(DTrafo))/2;

E = Strain(TrafoU);
DE = DStrain(TrafoU,TrafoV);
S = Sigma(E);
DS = DSigma(E, DE);

%Deformation energy
I3 = T2_colon_T2(DE , S) * TrafoDet;
I4 = T2_colon_T2(E , DS) * TrafoDet;

DPi = (I3+I4)/2;
end

function DDPi = energyDD(u,v,w,DTrafo, Sigma,DSigma,DDSigma, Strain,DStrain,DDStrain)
%get \nabla u(x), \nabla v(x) & \nabla w(x)
gradU = zeros(3,3);
gradV = zeros(3,3);
gradW = zeros(3,3);
for i=1:6
    gradBasis_i = displacement_basis(i,1); %gradBasis is constant on the referenz triangle
    
    gradU = gradU + u(i)*gradBasis_i([0,0]); 
    gradV = gradV + v(i)*gradBasis_i([0,0]); 
    gradW = gradW + w(i)*gradBasis_i([0,0]); 
end
TrafoU = DTrafo*gradU;
TrafoV = DTrafo*gradV;
TrafoW = DTrafo*gradW;
TrafoDet = abs(det(DTrafo))/2;

E = Strain(TrafoU);
DE_v = DStrain(TrafoU,TrafoV);
DE_w = DStrain(TrafoU,TrafoW);
DDE = DDStrain(TrafoU,TrafoV,TrafoW);
S = Sigma(E);
DS_w = DSigma(E,DE_w);
DS_v = DSigma(E,DE_v);
DDS = DDSigma(E,DE_v,DE_w);
DS_vw = DSigma(E,DDE);

I1 = T2_colon_T2(DDE, S) * TrafoDet;
I2 = T2_colon_T2(DE_v, DS_w) * TrafoDet;
I3 = T2_colon_T2(DE_w, DS_v) * TrafoDet;
I4 = T2_colon_T2(E, DDS) * TrafoDet;
I5 = T2_colon_T2(E, DS_vw) * TrafoDet;

DDPi = (I1+I2+I3+I4+I5)/2;
end