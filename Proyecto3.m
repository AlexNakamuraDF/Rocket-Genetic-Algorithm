%PROYECTO 3 IA-II
  pkg load statistics
%Para acceder a los archivos en carpetas
addpath('./Satellite_data');
addpath('./Satellite_info');
addpath('./rocket_simulation');
addpath('./GA');



%/////////////////////////////////////////////////////////////////////////////
%/////////////////////////////////////////////////////////////////////////////
%Project controls explanation
launch_site = [-3.6e6, 0]; %Given by the problem
%graph: if true, the program creates graph to show the rocket's path
%animation: if true, the program makes an animation of the interception of the rocket
%new_parameters: if true, the program uses the genetic algorithm to calculate...
                 %the launch parameters from scratch. I false it loads the...
                 % previously computed data from a file.
%max_generations denotes the maximum number of generations the genetic algorithm
    %allowed to have.
%population_size denotes the number of data sets per generation.
%file_simulation_number denotes the number of the file to read in case new_parameters is false
graph = true;
animation = true;
new_parameters = false;
max_generations = 10;
population_size = 50;
file_simulation_number = 1;
file_type = '.txt';
%/////////////////////////////////////////////////////////////////////////////

%Cargar la informaci�n de los sat�lites
load_satellite_info

%Leer archivos de texto para la informaci�n capturada por los sat�lites
Rocket_A_fp = fopen('Rocket_in_Sat_A.txt', 'r');
fgets(Rocket_A_fp);
Rocket_A = fscanf(Rocket_A_fp, '%f%f%f%f\n', [4, Inf])';

Rocket_B_fp = fopen('Rocket_in_Sat_B.txt', 'r');
fgets(Rocket_B_fp);
Rocket_B = fscanf(Rocket_B_fp, '%f%f%f%f\n', [4, Inf])';

Rocket_C_fp = fopen('Rocket_in_Sat_C.txt', 'r');
fgets(Rocket_C_fp);
Rocket_C = fscanf(Rocket_C_fp, '%f%f%f%f\n', [4, Inf])';

fclose(Rocket_A_fp);
fclose(Rocket_B_fp);
fclose(Rocket_C_fp);

datos3d = {Rocket_A, Rocket_B, Rocket_C};

%Reconstruir la posici�n del cohete en el espacio tridimencional.
xyz = posicion3D(datos3d, Satellites);
tiempo = Rocket_A(:,1); %Todos traen los mismos valores de tiempo

%Ajustar un polinomio al eje X
polyfit_x = polyfit(tiempo, xyz(:,1), 1);
  % Grado 1 porque es MRU
 
%Ajustar un polinomio al eje Y
polyfit_y = polyfit(tiempo, xyz(:,2), 1);
  % Grado 1 porque es MRU
  
%Ajustar un polinomio al eje Z
polyfit_z = polyfit(tiempo, xyz(:,3), 4);
  % Grado cuatro porque la simulaci�n toma en cuenta m�s cosas que la mera
  % aceleraci�n

%Gr�ficas de la estimaci�n del cohete con base en lo obtenido por los sat�lites
    polyval_x = polyval(polyfit_x,tiempo);
    polyval_y = polyval(polyfit_y,tiempo);
    polyval_z = polyval(polyfit_z,tiempo);
    
  if graph
    figure(1);
    subplot(4,1,1)
    plot3(xyz(:,1), xyz(:,2), xyz(:,3), 'rx-', polyval_x, polyval_y, polyval_z, 'b--');
      title('Trayectoria del cohete en tres dimensiones'),
      xlabel('x');
      ylabel('y');
      zlabel('z');

    subplot(4,1,2)
    plot(tiempo, xyz(:,1),'rx-', tiempo, polyval_x, 'b--')
      title('x')
      xlabel('t')
      ylabel('x')
    subplot(4,1,3)
    plot(tiempo, xyz(:,2), 'rx-', tiempo, polyval_y, 'b--')
      title('y')
      xlabel('t')
      ylabel('y')
    subplot(4,1,4)
    plot(tiempo, xyz(:,3), 'rx-', tiempo, polyval_z, 'b--')
      title('z')
      xlabel('t')
      ylabel('z')
   endif

% Dado que en los ejes X y Y son f�ciles de modelar (hacen una recta), 
% se puede simplificar la simulaci�n convirti�ndola a dos dimensiones:
% -La posici�n en esta recta
  angulo_direccion_cohete = sign(atan2(polyfit_y(1), polyfit_x(1)));
      %Se convierten los datos a este nuevo ajuste de una recta
      polyfit_x2d = [angulo_direccion_cohete, 1].*sqrt(polyfit_x.^2 + polyfit_y.^2);
% -La altura (esencialmente el eje z)
  polyfit_y2d = polyfit_z;

  
%graficar el vuelo observado en modelo de dos dimensiones
polyval_x2d = polyval(polyfit_x2d, tiempo);
polyval_y2d = polyval(polyfit_y2d, tiempo);

if graph
figure(2)
subplot(1,1,1)
plot(polyval_x2d, polyval_y2d, 'k--');
  title('Modelo de dos dimensiones')
  xlabel('distancia');
  ylabel('altura');
endif

%Derivar para encontrar el tiempo de altura m�xima
polyfit_dy2D_dt = [4*polyfit_y2d(1),3*polyfit_y2d(2),2*polyfit_y2d(3),polyfit_y2d(4)];
dY_dt = @(t) polyval(polyfit_dy2D_dt, t);
tiempo_maxima_altura = fzero(dY_dt, tiempo(end));


%Se comienza a modelar la predicci�n del vuelo
tiempo_prediccion = tiempo(end):(2*tiempo_maxima_altura);

vuelo_prediccion_x = polyval(polyfit_x2d, tiempo_prediccion);
vuelo_prediccion_y = polyval(polyfit_y2d, tiempo_prediccion);
vuelo_prediccion = [vuelo_prediccion_x; vuelo_prediccion_y]';


%Ver qu� parte de la predicci�n de vuelo no ha tocado el piso
indices_mayores_0 = vuelo_prediccion_y>0;
vuelo_prediccion_y = vuelo_prediccion_y(indices_mayores_0);
vuelo_prediccion_x = vuelo_prediccion_x(indices_mayores_0);
tiempo_prediccion = tiempo_prediccion(indices_mayores_0);
vuelo_prediccion = [vuelo_prediccion_x; vuelo_prediccion_y]';

%graph predicci�n
if graph
  figure(3)
  hold on
  plot(polyval_x2d, polyval_y2d, 'k-');
  plot(vuelo_prediccion_x, vuelo_prediccion_y, 'r--');
  title('Predicci�n de vuelo');
  hold off
endif

%Optimizar los par�metros de un cohete interceptor
if new_parameters
  parametros_control_optimizados = alg_gen(vuelo_prediccion, tiempo(end));
  %Guardar resultados en un archivo de texto
  guardarResultados(parametros_control_optimizados, max_generations, population_size);
else
  %Leer resultados anteriores
  parametros_control_optimizados = leerResultados(file_simulation_number, file_type)';
endif
  
%Simular el vuelo del cohete interceptor
trayectoria_interceptor = simulate_rocket(parametros_control_optimizados(1),...
        parametros_control_optimizados(2),launch_site,...
        tiempo(end) + parametros_control_optimizados(3));

%Mostrar intercepci�n
if animation
  figure(4)
  rocket_interception_simulation(vuelo_prediccion,trayectoria_interceptor);
endif



 