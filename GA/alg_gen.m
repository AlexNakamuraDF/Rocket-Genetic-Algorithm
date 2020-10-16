function xy_elite = alg_gen(target_trajectory, initial_time, varargin)
  %varargin{1} = max_generaciones
  %varargin{2} = tam_poblacion
  
  if numel(varargin)>=2
    max_generaciones = varargin{1};
    tam_poblacion = varargin{2};
  elseif numel(varargin)==1
    max_generaciones = varargin{1};
  else
    max_generaciones = 10;
    tam_poblacion = 50;  
  endif

  % Algoritmo Genetico:
  prob_cruza = 0.9;
  prob_mutacion= 0.2;

  num_genes = [5, 5, 5];
  xy_min = [2, -pi/16, 1];
  xy_max = [64, pi/16, 32];

  fx_elite = Inf;
  n_generaciones = 1;

  X = randi(2, tam_poblacion, sum(num_genes)) - 1;
  fx = zeros(tam_poblacion, 1);

  while true 
    XY = decodificar_poblacion(X, xy_min, xy_max, num_genes);
    for i = 1:tam_poblacion
      fx(i) = simulate_rocket_interception(XY(i,1), XY(i, 2), target_trajectory, [-3.6e6, 0], initial_time + XY(i, 3));
    end
    [min_fx, min_fx_i] = min(fx);
    display(['Generation: ', num2str(n_generaciones), ', min distance: ', num2str(min_fx), ' rotating after ', num2str(XY(min_fx_i, 1)), ' seconds ', num2str(XY(min_fx_i, 2)), ' radians, and launched after ', num2str(initial_time + XY(min_fx_i, 3))])
    if fx_elite > min(fx)
      [fx_elite, elite_i] = min(fx);
      elite = X(elite_i,:);
    end

    % Reinsertar al individuo elite:
    [~, max_fx_i] = max(fx);
    X(max_fx_i, :) = elite;
    fx(max_fx_i) = fx_elite;
    
    [probabilidad_seleccion, X] = seleccion(X, fx);
    H = cruza(X, probabilidad_seleccion, prob_cruza);
    X = mutacion(H, prob_mutacion);

    n_generaciones= n_generaciones+1;
    if n_generaciones >= max_generaciones
      break;
    end
  end

  xy_elite = decodificar_poblacion(elite, xy_min, xy_max, num_genes);
end