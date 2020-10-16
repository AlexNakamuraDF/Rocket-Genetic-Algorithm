function rho = compute_AirDensity(rocket_state)
  % If the rocket has hit the ground, the following operation prevents numeric errors:
  altitude = max([rocket_state.position(2), 0]);
  
  R = 8.3145; % m^3 Pa / mol degK
  M =  0.0289647; % in Kg/mol
  gh = compute_Gravity(rocket_state); % in m / s^2
  
  % The following parameters change according to the altitude of the rocket:
  heights_min = [0, 11e3, 20e3];
  heights_max = [11e3, 20e3, Inf];
  parameters = {[101325,	288.15,	-0.0065],...
  [22632.1,	216.65, 0], ...
  [5474.89,	216.65,	0.001]};

  % Height index:
  i = find((altitude >= heights_min) & (altitude < heights_max));
  
  % First the air pressura is calculated at the rocket's altitude:
  p0 = parameters{i}(1);
  T0 = parameters{i}(2);
  L = parameters{i}(3);
  T = T0 + L*(altitude - heights_min(i));
  if abs(L) > 1e-8
    air_pressure = p0 * (T0/ T).^(gh.*M./(R.*L));
  else
    air_pressure = p0 * exp((-gh*M*(altitude - heights_min(i)))/(R*T0));
  end
  
  % Then the air density is computed with the law of ideal gases:
  rho = M * air_pressure / (R * T);
end
