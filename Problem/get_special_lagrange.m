function lambda = get_special_lagrange()
  % must be defined with x = s(1)
  
  gradU = get_special_gradSolution();

  E=10;
  nu=0.3;
  lambda = nu/(1-2*nu)/(1+nu)*E;
  mu = E/(2+2*nu);
        
  % material law
  epsilon = @(x) (gradU(x) + gradU(x)')/2;
  sigma = @(x) lambda*trace(epsilon(x))*eye(3) + 2*mu*epsilon(x);
  
  % normal komponent on gamma_C
  n = @(x) [0;1;0];
  lambda = @(x) n(x)' * sigma(x) * n(x);
  
  %plot analytical solution
##  x1 = [-1:0.01:1];
##  x2 = x1*0;
##  x = [x1;x2];
##  val = x2;
##  for i=1:length(x1)
##      val(i) = lambda(x(:,i));
##  endfor
##  plot(x1, val, '-b')
  
endfunction
