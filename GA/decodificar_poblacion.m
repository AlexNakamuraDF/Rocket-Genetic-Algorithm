function xy = decodificar_poblacion(poblacion, xy_min, xy_max, num_genes)
  [n, m] = size(poblacion);
  n_vars = length(num_genes);
  
  potencias_2 = zeros(m, n_vars);
  max_potencias = zeros(1, n_vars);
  j = 0;
  for i = 1:length(num_genes)
    potencias_2((1:num_genes(i)) + j, i) = 2.^[0:(num_genes(i)-1)];
    max_potencias(i) = 2^num_genes(i) - 1;
    j = j + num_genes(i);
  end
  
  decodificado = (poblacion * potencias_2) ./ repmat(max_potencias, [n, 1]);
  
  rango_xy = xy_max - xy_min;
  xy = decodificado .* repmat(rango_xy, [n, 1]) + repmat(xy_min,[n,1]);
end