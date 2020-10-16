function R = rotation_Matrix2d(angle)
  % Rotation matrix must be used as: u = v * R
  R = [cos(-angle), -sin(-angle); sin(-angle), cos(-angle)];
end
