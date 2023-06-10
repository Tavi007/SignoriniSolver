function output = T2_colon_T2(A,B)
%computes A:B
if size(A,1) ~= size(B,1) || size(A,2) ~= size(B,2)
    error('Dimension error')
end
output = sum(sum(A.*B));
end

