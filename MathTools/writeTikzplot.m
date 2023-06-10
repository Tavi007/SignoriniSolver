function writeTikzplot(filename, dataList, colorList)
  %write tikzplot for each material
  
  noCases = numel(dataList);
  
  maxValues = 0;
  for i = 1:noCases
    data = dataList{i};
    noValues = length(data);
    if maxValues < noValues
      maxValues = noValues;
    end
  end
  
  
  %Open file
  FID = fopen(filename,'w+');
  %Header
  fprintf(FID, '\\begin{tikzpicture}[every plot/.append style={thick}] \n');
  fprintf(FID, '\\begin{axis}[ \n');
  fprintf(FID, 'label style={font=\\normalsize}, \n');
  fprintf(FID, 'xlabel={Newton-Iteration}, \n');
  fprintf(FID, 'ylabel={Residuum}, \n');
  fprintf(FID, 'xmin=0, xmax=%u, \n', maxValues-1);
  fprintf(FID, 'ymode=log, \n');
  fprintf(FID, 'ymin=0, ymax=10, \n');       
  fprintf(FID, 'width=0.9\\textwidth, \n');
  fprintf(FID, 'grid style=dashed, \n');
  fprintf(FID, '] \n');
  
  for i=1:noCases
    data = dataList{i};
    noValues = length(data);
    
    fprintf(FID, '\\addplot[ \n');
    fprintf(FID, 'color=%s, \n', colorList{i});
    fprintf(FID, '] \n');
    
    %actual value plotting
    fprintf(FID, 'coordinates { \n');
    for j=1:noValues
      if data(j) >= 1e-20
        fprintf(FID, '(%u, %1.2e)', j-1, data(j));
      else
        fprintf(FID, '(%u, %1.2e)', j-1, 1e-20);
      end
    end
    fprintf(FID, '}; \n');
  end
  %end tikz
  fprintf(FID, '\\end{axis} \n');
  fprintf(FID, '\\end{tikzpicture} \n');
  fclose(FID);
  
  
endfunction
