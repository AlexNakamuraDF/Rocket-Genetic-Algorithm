function guardarResultados(resultados, varargin)
  %varargin{1} = max_generaciones
  %varargin{2} = tam_poblacion
  
  %Para poder incluir en el archivo
  if numel(varargin)>=2
    max_generaciones = varargin{1};
    tam_poblacion = varargin{2};
  elseif numel(varargin)==1
    max_generaciones = varargin{1};
  else
    max_generaciones = 10;
    tam_poblacion = 50;  
  endif
  
  name_base = 'Parametros_GA_';
  file_type = '.txt';
  
  %Checar si existe ya el archivo para que no se encime
  n = 1;
  while true
    filename = [name_base,int2str(n),file_type]; 
    e = exist(filename, "file");
    if e == 0
      break
    else
      n = n + 1;
    endif
  endwhile  
  
  %Abrir y escribir archivo
  archivo = fopen(filename,'wt');
  
  fprintf(archivo, [name_base,int2str(n), '\n']);
  fprintf(archivo, 'Max_Generaciones = %i\n', max_generaciones);
  fprintf(archivo, 'Tamano_Poblacion = %i\n', tam_poblacion);
  fprintf(archivo,'Parametros de control obtenidos:\n');
  fprintf(archivo, '%f %f %f', resultados);
  
  fclose(archivo);  
endfunction
