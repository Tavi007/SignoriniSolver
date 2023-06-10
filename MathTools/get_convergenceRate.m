function TableRate = get_convergenceRate(Table)
    
    noMaterial = size(Table,1);
    noContactTypes = size(Table,2);
    TableRate = cell(noMaterial,noContactTypes);
    
    for materialID = 1:noMaterial
        for contactTypeID = 1:noContactTypes
            X = Table{materialID, contactTypeID}; %Table of values
            
            Y = ones(size(X,1),size(X,2))*NaN;
            %compute convergenceRate
            for j = 1:size(Y,2) %row iter
                for i = 2:size(Y,1) %column iter; i=1 -> equilibrium, i=2 -> contact
                    previousValue = X(i-1,j);
                    currentValue = X(i,j);
                    
                    %check of NaN
                    if ~isnan(previousValue) && ~isnan(currentValue)
                        if previousValue == 0 || currentValue == 0
                            Y(i,j) = NaN;
                        else
                            Y(i,j) = log10(previousValue/currentValue);
                        end
                    end
                end
            end
            TableRate{materialID,contactTypeID} = Y;
        end
    end
end
