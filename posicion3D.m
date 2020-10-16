function xyz = posicion3D(datos3d, satelites)
  NA = satelites(1).normal;
  NB = satelites(2).normal;
  NC = satelites(3).normal;
  Matriz_sistema =[2*NA * NA',-NA*NB',-NA*NC';...
                   -NA*NB',2*NB*NB',-NB*NC';...
                    -NA*NC',-NB*NC',2*NC*NC'];
  [n_puntos,~] = size(datos3d{1});
  xyz = zeros(n_puntos,3);
  for p =1:n_puntos
    SA = datos3d{1}(p,2:4);
    SB = datos3d{2}(p,2:4);
    SC = datos3d{3}(p,2:4);
    
    vector_sistema = [(SB +  SC -2*SA)*NA';...
                      (SA + SC - 2*SB)*NB';...
                      (SA + SB -2*SC)*NC'];
    t_abc = Matriz_sistema \ vector_sistema;
    xyz(p,:) = ( (SA + NA*t_abc(1)) + (SB + NB*t_abc(2)) + (SC + NC*t_abc(3)) )/3;
  endfor
end