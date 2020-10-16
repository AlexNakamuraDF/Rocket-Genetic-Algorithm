function rocket_state = update_RocketState(rocket_state , time_increment)
  % First the rocket's pitch angle is updated:
  rocket_state = update_RocketPitchAnglularAcceleration(rocket_state, time_increment);  
  rocket_state = update_RocketPitchAngle(rocket_state, time_increment);
  
  % Then the rocket's position, velocity and acceleration are updated respectively:
  rocket_state = update_RocketAcceleration(rocket_state);
  rocket_state = update_RocketVelocity(rocket_state, time_increment);  
  rocket_state = update_RocketPosition(rocket_state, time_increment);
  
  % The fuel mass is updated with the corresponding fuel consumption rate:
  rocket_state.fuel_mass = max([rocket_state.fuel_mass - rocket_state.fuel_consumption*time_increment, 0]);
end


function rocket_state = update_RocketPosition(rocket_state, time_increment)  
  rocket_state.position = rocket_state.position + rocket_state.velocity * time_increment;
end


function rocket_state = update_RocketVelocity(rocket_state, time_increment)  
  rocket_state.velocity = rocket_state.velocity + rocket_state.acceleration * time_increment;
end


function rocket_state = update_RocketAcceleration(rocket_state)
  % Get the rocket's mass at the current time:
  rocket_total_mass = rocket_state.fuel_mass + rocket_state.mass_empty;
  
  % Compute the thrust force along the rocket's body:
  rocket_thrust_force = (rocket_state.fuel_mass > 1e-6)  * rocket_state.exhaust_velocity * rocket_state.fuel_consumption  * cos(rocket_state.gimbal_angle);
  
  % Compute the Weight force:
  Weight = [0, - rocket_total_mass*compute_Gravity(rocket_state)];
  Weight(abs(Weight) < 1e-6) = 0;
  
  % If the rocket is in ground, the Normal force is computed:
  Normal = -Weight * (rocket_state.position(2) < 1e-6);
  
  % Thrust force is rotated to the rocket body axis
  Thrust = [0, rocket_thrust_force] * rotation_Matrix2d(rocket_state.pitch_angle);
  Thrust(abs(Thrust) < 1e-6) = 0;
  
  % Drag is computed according to the current rocket's velocity:
  Drag = compute_DragForce(rocket_state);
  Drag(abs(Drag)<1e-6) = 0;
  
  % Acceleration is computed as the sum of all forces:
  rocket_state.acceleration = (Thrust + Normal + Drag + Weight)/rocket_total_mass;
end


function rocket_state = update_RocketPitchAngle(rocket_state, time_increment)
  % No angular velocity is taken into account because the gimbaling action is considered to be instantly
  rocket_state.pitch_angle = rocket_state.pitch_angle + rocket_state.pitch_angular_acceleration * time_increment.^2;
end

function rocket_state = update_RocketPitchAnglularAcceleration(rocket_state, time_increment)
  % Angular acceleration is considered to be applied instantly, due to a nozzle gimbaling in deprecable time:
  rocket_thrust_force = (rocket_state.fuel_mass > 1e-6)  * rocket_state.exhaust_velocity * rocket_state.fuel_consumption  * sin(rocket_state.gimbal_angle);
  rocket_total_mass = rocket_state.fuel_mass + rocket_state.mass_empty;
  
  rocket_state.pitch_angular_acceleration = 6 * rocket_thrust_force / (rocket_total_mass * rocket_state.body_height);
end