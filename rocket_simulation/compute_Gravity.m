function g_h = compute_Gravity(rocket_state)
  g0 = 9.80655; % Gravitational acceleration: 9.80665 m/s^2 at sea level
  
  % The max operation prevents the generation of negative acceleration due to gravity attraction of the Earth:
  g_h = max([g0 * (1 - 2*rocket_state.position(2)/6367.5e3), 0]);
end
