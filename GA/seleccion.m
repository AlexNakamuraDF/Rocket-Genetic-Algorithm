function [probabilidad_seleccion, X] = seleccion(X, fx)

  fx = max(fx) - fx + 1;
  
  [probabilidad_seleccion, orden_fx] = sort( fx / sum(fx),  'descend');
  probabilidad_seleccion = cumsum(probabilidad_seleccion);
  
  X = X(orden_fx, :);
end