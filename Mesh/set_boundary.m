function mesh = set_boundary(mesh, problem)
%updates mesh depending on the boundary of the problem.
%mesh.gammaD, mesh.gammaN and mesh.gammaC include the ids of the
%corresponding vertices in these sets.

 
noVert = mesh.noVert;
noEdge = mesh.noEdge;
mesh.gammaDVertId = [];
mesh.notCVertId = [];
mesh.gammaCVertId = [];
mesh.gammaNEdgeId = [];
mesh.gammaCEdgeId = [];
for i = 1:noVert
    if problem.phiD(mesh.vertices(i,:)) == 0 %if vert is in gammaD
        mesh.gammaDVertId = [mesh.gammaDVertId;i];
    end
    if problem.phiC(mesh.vertices(i,:)) ~= 0 %if vert is not in gammaC
        mesh.notCVertId = [mesh.notCVertId, i];
    end
end
for i = 1:noEdge
    edge = mesh.edges(i,:);
    a = mesh.vertices(edge(1),:);
    b = mesh.vertices(edge(2),:);
    if abs(problem.phiC(a)-a(2)) <= 10e-10  && abs(problem.phiC(b)-b(2)) <= 10e-10 %if edge is in gammaC
        mesh.gammaCEdgeId = [mesh.gammaCEdgeId;i];  
        
        VertId1 = mesh.edges(i,1);
        VertId2 = mesh.edges(i,2);
        
        
        if ~ismember(VertId1, mesh.gammaCVertId)    
            mesh.gammaCVertId = [mesh.gammaCVertId;VertId1];
        end
        if ~ismember(VertId2, mesh.gammaCVertId)
            mesh.gammaCVertId = [mesh.gammaCVertId;VertId2];
        end
    end
end
%sort gammaCVertId to local numbering
CVertX = mesh.vertices(mesh.gammaCVertId,1);
[CVertX , indexSorting] = sort(CVertX);
mesh.gammaCVertId = mesh.gammaCVertId(indexSorting);

mesh.noCVert = size(mesh.gammaCVertId,1);
mesh.noCEdge = size(mesh.gammaCEdgeId,1);

end
