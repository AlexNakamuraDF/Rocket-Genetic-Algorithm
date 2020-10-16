function M = mutacion(X, prob_mutacion)
  [n, m] = size(X);
  
  indice_mutacion = randsample(1:n, ...
  floor(n * prob_mutacion));
  
  M = X;
  
  for i_m = indice_mutacion
    m_g = randsample(1:m, randi(m, 1));
    M(i_m, m_g) = 1 - M(i_m, m_g);
  end
end