function input = include_bdr_conditions(input, mesh, problem)

ids = [mesh.gammaDVertId; mesh.gammaDVertId+ones(length(mesh.gammaDVertId),1)*mesh.noVert];
if size(input,2) == 1 %case vector
    input(ids) = problem.dirichlet(mesh.vertices(mesh.gammaDVertId,:));
else %case matrix
    input(ids,:) = 0;
    for i = 1:size(ids,1)
        input(ids(i),ids(i)) = 1;
    end
end
end
