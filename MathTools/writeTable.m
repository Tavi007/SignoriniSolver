function writeTable(Filepath, Table, obstacleName, mesh, contactTypeList, materialLawList)
    %Schreibt eine Matrix in eine Datei und nutzt '&' als Trennungszeichen.
    
    level = mesh.level;
    TableRate = get_convergenceRate(Table);
    
    Filepath = strcat(Filepath, 'Table/');
    mkdir(Filepath);
    filenameResiduum = strcat(Filepath, 'Residuum_', obstacleName, '_level', num2str(level));
    filenameRate = strcat(Filepath, 'Rate_', obstacleName, '_level', num2str(level));
    
    %Open residuum file
    FID = fopen(strcat(filenameResiduum,'.tex'),'w+');
    %begin table
    fprintf(FID, '\\begin{table} \n');
    fprintf(FID, '\\centering \n');
    writeTabular(FID, Table, contactTypeList, materialLawList, '%10.2e');
    %caption and label
    caption = strcat('\\caption{Residuen mit Hinderniss ''', obstacleName, ''' auf Gitterlevel %u .}');
    label = strcat('\\label{tab:Residuum_',obstacleName,'_level', num2str(level), '}');
    fprintf(FID, caption, level);
    fprintf(FID,label);
    fprintf(FID,'\n');
    fprintf(FID,'\\end{table} \n');
    fclose(FID);

    %Open convergencerate file
    FID = fopen(strcat(filenameRate,'.tex'),'w+');
    %begin table
    fprintf(FID, '\\begin{table} \n');
    fprintf(FID, '\\centering \n');
    writeTabular(FID, TableRate, contactTypeList, materialLawList, '%10.2f');
    %caption and label
    caption = strcat('\\caption{Kovergenzraten mit Hinderniss ''', obstacleName, ''' mit %u Freiheitsgraden für die Verschiebung.}');
    label = strcat('\\label{tab:Rate_',obstacleName,'_level', num2str(level), '}');
    fprintf(FID, caption, mesh.noVert*2);
    fprintf(FID,label);
    fprintf(FID,'\n');
    fprintf(FID,'\\end{table} \n');
    fclose(FID);
end

function writeTabular(FID, Table, contactTypeList, materialLawList, dataFormat)
    noMaterial = numel(materialLawList);
    noContact = numel(contactTypeList);
    
    %begin tabular
    fprintf(FID, '\\begin{tabular}{');
    fprintf(FID, 'c|');    
    for i = 1:noContact
        fprintf(FID, 'cc|');
    end
    fprintf(FID, '} \n');
    %Header
    fprintf(FID, strcat('\\cline{2-', num2str(noContact*2+1), '} \n'));
    fprintf(FID, ' & ');
    for i =1:noContact
        switch contactTypeList{i}
        case 'linear'
            fprintf(FID, '\\multicolumn{2}{|c|}{Linearer Kontakt}');
        case 'nonlinear'
            fprintf(FID, '\\multicolumn{2}{|c|}{Allgemeiner Kontakt}');
        case 'linear normiert'
            fprintf(FID, '\\multicolumn{2}{|c|}{Linearer (normierter) Kontakt}');
        end
        
        if i == noContact
            fprintf(FID, ' \\\\ \n');
        else
            fprintf(FID, ' & ');
        end
    end
    fprintf(FID, '\\hline \n');
    
    %Data and caption on the left
    fprintf(FID, '\\multicolumn{1}{|c|}{Materialgesetz} & ');
    for i =1:noContact
        fprintf(FID, '\\multicolumn{1}{c|}{Verformung} & \\multicolumn{1}{c|}{NCP}');
        
        if i == noContact
            fprintf(FID, ' \\\\ \n');
        else
            fprintf(FID, ' & ');
        end
    end
    fprintf(FID, '\\hline \n');
    
    for materialID = 1:noMaterial
        material = materialLawList{materialID};
        
        %maximum number of iteration for this material
        noValuesPerMaterial = 0;
        for contactTypeID = 1:noContact
            Data = Table{materialID,contactTypeID};
            maxValuesOfThisCase = size(Data,1);
            if noValuesPerMaterial < maxValuesOfThisCase
                noValuesPerMaterial = maxValuesOfThisCase;
            end
        end
        %fill Data with NaNs
        for contactTypeID = 1:noContact
            Data = Table{materialID,contactTypeID};
            filled = false;
            while ~filled
                maxValuesOfThisCase = size(Data,1);
                if maxValuesOfThisCase < noValuesPerMaterial
                    Data = [Data; ones(1,2)*NaN];
                else
                    filled = true;
                end
            end
            Table{materialID,contactTypeID} = Data;
        end
        
        fprintf(FID, strcat('\\multicolumn{1}{|c|}{\\multirow{',num2str(noValuesPerMaterial),'}{*}{',material,'}} &  '));
        
        for i = 1:noValuesPerMaterial
            if i ~= 1
                fprintf(FID, '\\multicolumn{1}{|c|}{} & ');
            end
            
            for contactTypeID = 1:noContact
                Data = Table{materialID, contactTypeID};
                sizeX = size(Data,2);
                
                for j = 1:sizeX
                    if ~isnan(Data(i,j))
                        fprintf( FID, strcat('\\multicolumn{1}{|c|}{',dataFormat,'}'), Data(i,j) );
                    else
                        fprintf( FID, '\\multicolumn{1}{|c|}{}');
                    end
                    
                    if j ~= sizeX
                        fprintf(FID, ' & ');
                    end
                end
                        
                if contactTypeID == noContact
                    fprintf(FID, ' \\\\ \n');
                else
                    fprintf(FID, ' & ');
                end
            end %end contacType loop
            
        end %end noValuesPerMaterial loop
        fprintf(FID, '\\hline \n');
    end % end noMaterial loop
    
    %end tabular
    fprintf(FID, '\\end{tabular}');
end