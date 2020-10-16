function Drag = compute_DragForce(rocket_state)
  % Get the velocity along the rocket body axis:
  rocket_velocity = sqrt(sum(rocket_state.velocity.^2));
  if rocket_velocity > 1e-10
    rocket_angle = atan2(rocket_state.velocity(2)/rocket_velocity, rocket_state.velocity(1)/rocket_velocity);
  else
    rocket_angle = pi/2;
  end
  
  %  Compute the drag caused along the rocket's body:
  Drag = 0.5 *  rocket_state.drag_coefficient .* compute_AirDensity(rocket_state) .* rocket_state.nose_area .* rocket_velocity.^2;
  
  % Rotate the drag force to make it relative to the horizon:
  Drag = Drag * [-1, 0] * rotation_Matrix2d(rocket_angle);
end