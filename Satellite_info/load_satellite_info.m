ref_Z = [0, 0, 1];
ref_Y = [0, 1, 0];
ref_X = [-1, 0, 0];

Satellites(1).position = [4.29, -34.25, 10.20]*1e6; % In kilometers
Satellites(1).normal = -Satellites(1).position/sqrt(Satellites(1).position*Satellites(1).position');
rotation_Z = align_Matrix(ref_Y, Satellites(1).normal, ref_Z);
ref_Z = ref_Z * rotation_Z;
ref_Y = ref_Y * rotation_Z;
ref_X = ref_X * rotation_Z;
rotation_X = align_Matrix(ref_Y, Satellites(1).normal, ref_X);
ref_Z = ref_Z * rotation_X;
ref_Y = ref_Y * rotation_X;
ref_X = ref_X * rotation_X;
Satellites(1).rotation = rotation_Z*rotation_X;
Satellites(1).resolution = [1920, 1920];
Satellites(1).scale = 5e6;
Satellites(1).aspect_ratios = Satellites(1).resolution / max(Satellites(1).resolution);



ref_Z = [0, 0, 1];
ref_Y = [0, 1, 0];
ref_X = [-1, 0, 0];

Satellites(2).position = [28.57, 14.02, 16.81]*1e6;
Satellites(2).normal = -Satellites(2).position/sqrt(Satellites(2).position*Satellites(2).position');
rotation_Z = align_Matrix(ref_Y, Satellites(2).normal, ref_Z);
ref_Z = ref_Z * rotation_Z;
ref_Y = ref_Y * rotation_Z;
ref_X = ref_X * rotation_Z;
rotation_X = align_Matrix(ref_Y, Satellites(2).normal, ref_X);
ref_Z = ref_Z * rotation_X;
ref_Y = ref_Y * rotation_X;
ref_X = ref_X * rotation_X;
Satellites(2).rotation = rotation_Z*rotation_X;
Satellites(2).resolution = [1920, 1920];
Satellites(2).scale = 5e6;
Satellites(2).aspect_ratios = Satellites(2).resolution / max(Satellites(2).resolution);




ref_Z = [0, 0, 1];
ref_Y = [0, 1, 0];
ref_X = [-1, 0, 0];

Satellites(3).position = [13.30, -8.94, 32.23]*1e6;
Satellites(3).normal = -Satellites(3).position/sqrt(Satellites(3).position*Satellites(3).position');
rotation_Z = align_Matrix(ref_Y, Satellites(3).normal, ref_Z);
ref_Z = ref_Z * rotation_Z;
ref_Y = ref_Y * rotation_Z;
ref_X = ref_X * rotation_Z;
rotation_X = align_Matrix(ref_Y, Satellites(3).normal, ref_X);
ref_Z = ref_Z * rotation_X;
ref_Y = ref_Y * rotation_X;
ref_X = ref_X * rotation_X;
Satellites(3).rotation = rotation_Z*rotation_X;
Satellites(3).resolution = [1920, 1920];
Satellites(3).scale = 5e6;
Satellites(3).aspect_ratios = Satellites(3).resolution / max(Satellites(3).resolution);


clear ref_X ref_Y ref_Z rotation_X rotation_Z