function positions = simulate_rocket(rotation_time, rotation_angle, initial_position, initial_time)
  % Simulate a rocket launch
  rocket_state.mass_empty = 1317; % Rocket body mass with out fuel in kilograms
  rocket_state.fuel_mass = 0; % Mass  of fuel only in kilograms
  rocket_state.exhaust_velocity = 2100; % Velocity generated by the rocket engine in m/s
  rocket_state.nose_area =  pi * (2.11/2)^2; % Area of the rocket's nose in squared meters
  rocket_state.body_height = 10.39; % Height of the rocket's body in meters
  rocket_state.drag_coefficient = 0.4; % Drag coefficient generated by the rockets shape

  rocket_state.fuel_consumption = 216.6; % Engine fuel consumption in kg/s

  rocket_state.pitch_angle = 0; % Angle of the rocket's body relative to the horizon in radians
  rocket_state.gimbal_angle = 0; % Angle of the nozzle relative to the rocket's body in radians
  rocket_state.pitch_angular_acceleration = 0; % Angula acceleration due to nozzles gimbaling in radians/s^2

  rocket_state.position = initial_position; % Current rocket's position relative to the launching position
  rocket_state.velocity = [0, 0]; % Current rocket's velocity relative to the horizon
  rocket_state.acceleration = [0, 0]; % Current rocket's acceleration relative to the horizon

  time_increment = 1;
  elapsed_time = 0;

  positions = zeros(floor(3000/time_increment)+1, 2);
  
  while elapsed_time < 3000 && rocket_state.position(2) > -1e-6
      % Control del despegue:
      if elapsed_time == initial_time
        rocket_state.fuel_mass = 28158;
      end
      
      % Control de la tobera
      if elapsed_time == (rotation_time + initial_time)
        rocket_state.gimbal_angle = rotation_angle;
      end
      
      if elapsed_time == (rotation_time + initial_time + 1)
        rocket_state.gimbal_angle = 0;
      end
           
      elapsed_time = elapsed_time + 1;
      rocket_state = update_RocketState(rocket_state, time_increment);
      positions(elapsed_time, :) = rocket_state.position;
  end
  
  positions = positions(1:elapsed_time, :);
end