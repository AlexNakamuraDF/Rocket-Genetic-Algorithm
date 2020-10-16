function R = align_Matrix(vec_A, vec_B, rotation_axis)
  if nargin < 3
    rotation_axis = cross(vec_A, vec_B);
  else
    
    vec_A_2 = cross(vec_B, rotation_axis);
    vec_B = cross(vec_A, rotation_axis);
    vec_A = vec_A_2;
  end
  
  rotation_axis = rotation_axis / sqrt(rotation_axis*rotation_axis');
  cos_theta = vec_A*vec_B'/(sqrt(vec_A*vec_A')*sqrt(vec_B*vec_B'));
  sin_theta = sqrt(1 - cos_theta^2);
  
  mat_W = [0, -rotation_axis(3), rotation_axis(2);rotation_axis(3), 0, -rotation_axis(1);-rotation_axis(2), rotation_axis(1), 0];
  
  R = (eye(3) + sin_theta * mat_W + (1-cos_theta)*mat_W*mat_W)';
end
