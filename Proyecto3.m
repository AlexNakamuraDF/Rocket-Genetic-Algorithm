%PROYECTO 3 IA-II
  pkg load statistics
%Para acceder a los archivos en carpetas
addpath('./Satellite_data');
addpath('./Satellite_info');
addpath('./rocket_simulation');
addpath('./GA');


%/////////////////////////////////////////////////////////////////////////////
%CONTROLES DEL PROYECTO
%Para saber si hacer gráficas
graficar = false;
simulacion_grafica = true;

generar_nuevos_parametros = false;
% -True = ejecutar AG para nuevos parametros
      max_generaciones = 10;
      tam_poblacion = 50;
% -False = leer un archivo de una simulacion previa
      file_simulation_number = 3; %Número del archivo de simulación a leer 
      file_type = '.txt';

%/////////////////////////////////////////////////////////////////////////////

%Cargar la información de los satélites
load_satellite_info

%Leer archivos de texto para la información capturada por los satélites
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

%Reconstruir la posición del cohete en el espacio tridimencional.
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
  % Grado cuatro porque la simulación toma en cuenta más cosas que la mera
  % aceleración

%Gráficas de la estimación del cohete con base en lo obtenido por los satélites
    polyval_x = polyval(polyfit_x,tiempo);
    polyval_y = polyval(polyfit_y,tiempo);
    polyval_z = polyval(polyfit_z,tiempo);
    
  if graficar
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

% Dado que en los ejes X y Y son fáciles de modelar (hacen una recta), 
% se puede simplificar la simulación convirtiéndola a dos dimensiones:
% -La posición en esta recta
  angulo_direccion_cohete = atan2(polyfit_y(1), polyfit_x(1));
      %Se convierten los datos a este nuevo ajuste de una recta
      polyfit_x2d = [angulo_direccion_cohete, 1].*sqrt(polyfit_x.^2 + polyfit_y.^2);
% -La altura (esencialmente el eje z)
  polyfit_y2d = polyfit_z;

  
%Graficar el vuelo observado en modelo de dos dimensiones
polyval_x2d = polyval(polyfit_x2d, tiempo);
polyval_y2d = polyval(polyfit_y2d, tiempo);

if graficar
figure(2)
subplot(1,1,1)
plot(polyval_x2d, polyval_y2d, 'k--');
  title('Modelo de dos dimensiones')
  xlabel('distancia');
  ylabel('altura');
endif

%Derivar para encontrar el tiempo de altura máxima
polyfit_dy2D_dt = [4*polyfit_y2d(1),3*polyfit_y2d(2),2*polyfit_y2d(3),polyfit_y2d(4)];
dY_dt = @(t) polyval(polyfit_dy2D_dt, t);
tiempo_maxima_altura = fzero(dY_dt, tiempo(end));


%Se comienza a modelar la predicción del vuelo
tiempo_prediccion = tiempo(end):(2*tiempo_maxima_altura);

vuelo_prediccion_x = polyval(polyfit_x2d, tiempo_prediccion);
vuelo_prediccion_y = polyval(polyfit_y2d, tiempo_prediccion);
vuelo_prediccion = [vuelo_prediccion_x; vuelo_prediccion_y]';


%Ver qué parte de la predicción de vuelo no ha tocado el piso
indices_mayores_0 = vuelo_prediccion_y>0;
vuelo_prediccion_y = vuelo_prediccion_y(indices_mayores_0);
vuelo_prediccion_x = vuelo_prediccion_x(indices_mayores_0);
tiempo_prediccion = tiempo_prediccion(indices_mayores_0);
vuelo_prediccion = [vuelo_prediccion_x; vuelo_prediccion_y]';

%Graficar predicción
if graficar
  figure(3)
  hold on
  plot(polyval_x2d, polyval_y2d, 'k-');
  plot(vuelo_prediccion_x, vuelo_prediccion_y, 'r--');
  title('Predicción de vuelo');
  hold off
endif

%Optimizar los parámetros de un cohete interceptor
if generar_nuevos_parametros
  parametros_control_optimizados = alg_gen(vuelo_prediccion, tiempo(end));
  %Guardar resultados en un archivo de texto
  guardarResultados(parametros_control_optimizados, max_generaciones, tam_poblacion);
else
  %Leer resultados anteriores
  parametros_control_optimizados = leerResultados(file_simulation_number, file_type)';
endif
  
%Simular el vuelo del cohete interceptor
sitio_lanzamiento = [-3.6e6, 0];
trayectoria_interceptor = simulate_rocket(parametros_control_optimizados(1),...
        parametros_control_optimizados(2),sitio_lanzamiento,...
        tiempo(end) + parametros_control_optimizados(3));

%Mostrar intercepción
if simulacion_grafica
  figure(4)
  rocket_interception_simulation(vuelo_prediccion,trayectoria_interceptor);
endif



 