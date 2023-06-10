function Table = filterTable(Table)
    
    %filter values under 10e-20 to be exact 10e-20. For logarithmic plot.
    sizeX = size(Table,1);
    sizeY = size(Table,2);
    
    for i=1:sizeX
        for j=1:sizeY
            Data = Table{i,j};
            sizeDataY = size(Data,1);
            sizeDataX = size(Data,2);
            for k=1:sizeDataY    
                for l=1:sizeDataX
                if Data(k,l) < 1e-20
                    Data(k,l) = 1e-20;
                end
            end
            Table{i,j} = Data;
        end
    end
    
end
