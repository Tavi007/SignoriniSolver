function material = materialConstants(material)
%returns the correct material parameters mu and lambda for given
%material.name. From page 129 Ciarlet

%TODO: add SI units
if strcmp(material.name,'steel')
    material.para.lambda = 10; %10^5 kg/(cm^2) 
    material.para.mu = 8.2; %10^5 kg/(cm^2)   
    
elseif strcmp(material.name,'rubber')
    material.para.lambda = 0.4; %10^5 kg/(cm^2) 
    material.para.mu = 0.012; %10^5 kg/(cm^2) 
    
elseif strcmp(material.name,'special')
    material.para.lambda = 0.4; %10^5 kg/(cm^2) 
    material.para.mu = 0.012; %10^5 kg/(cm^2) 
else
    error('unknown material name')
end
end

