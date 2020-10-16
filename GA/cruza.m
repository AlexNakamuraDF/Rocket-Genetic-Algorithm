function H = cruza(X, P, prob_cruza)
  [n, m]  = size(X);
  
  indices_cruza = randsample(1:n, ...
  floor(prob_cruza*n));
  
  H = X;
  
  for i_c = indices_cruza
    rand_p1 = rand(1);
    R_p1 = find(([0, P(1:(end-1))'] <= rand_p1) & ...
                (P' > rand_p1));
      R_p2 = R_p1;
      while R_p2 == R_p1
            rand_p2 = rand(1);
            R_p2 = find(([0, P(1:(end-1))'] <= rand_p2) & ...
                (P' > rand_p2));
      end
      punto_cruza = randi(m-1, 1);
      H(i_c, 1:punto_cruza) = X(R_p1, 1:punto_cruza);
      H(i_c, (punto_cruza+1):end) = X(R_p2, (punto_cruza+1):end);
  end
  
 end 