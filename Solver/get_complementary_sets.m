function [A_local,I_local] = get_complementary_sets(d_p, lambda, mesh, solverPara)
%For given u =u^{k-1} , lambda = lambda^{k-1} and function d
%computes the aktive set A and inaktive set I with local numbering

noCVert = mesh.noCVert;

A_local = [];
I_local = [];
c = solverPara.scaleComplementary;

for i = 1:noCVert %loop over all contact verticies ('local' numbering)
    val = lambda(i) + c*d_p(i);
    if val < 0 %Add id to set
        A_local = [A_local,i];
    else
        I_local = [I_local,i];
    end
end

end

