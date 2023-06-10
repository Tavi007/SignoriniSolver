function D = assembly_rotation(u, mesh, problem,solverPara)

noVert = mesh.noVert;
noCVert = mesh.noCVert;

D = sparse(eye(noVert*2, noVert*2));
for i = 1:noCVert
    CVertId = mesh.gammaCVertId(i);
    ids = [CVertId, CVertId+noVert];
    CVert = mesh.vertices(CVertId,:)';
    u_CVert = u(ids);
    
    n = get_normal(CVert, u_CVert, problem,solverPara);
    n=n/norm(n);
    tau = [-n(2), n(1)];
    D_local = [n; tau];
    
    D(ids,ids) = D_local;
end
    
end