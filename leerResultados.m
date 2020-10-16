function resultados = leerResultados(file_num, filetype)
  archivo = fopen(['Parametros_GA_',int2str(file_num), filetype], 'r');
  fgets(archivo);
  fgets(archivo);
  fgets(archivo);
  fgets(archivo);
  resultados = fscanf(archivo, '%f %f %f', [3, 1]);
  fclose(archivo);
endfunction
