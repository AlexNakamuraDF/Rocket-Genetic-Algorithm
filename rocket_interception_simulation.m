function rocket_interception_simulation(positions_1, positions_2)
  plot(positions_1(:,1), positions_1(:,2), 'r.', positions_2(:,1), positions_2(:,2), 'b--');
  hold on
  rocket_1 = plot(positions_1(1,1), positions_1(1,2), 'rx');
  rocket_2 = plot(positions_2(1,1), positions_2(1,2), 'bo');
  hold off
  [elapsed_time_1, ~] = size(positions_1);
  [elapsed_time_2, ~] = size(positions_2);
  
  min_elapsed_time = min([elapsed_time_1,elapsed_time_2]);
  min_distance = Inf;
  nearest_time = 0;
  for t = 1:min_elapsed_time
    set(rocket_1, 'XData', positions_1(t, 1), 'YData', positions_1(t, 2));
    set(rocket_2, 'XData', positions_2(t, 1), 'YData', positions_2(t, 2));
    distance = sqrt(sum((positions_1(t,:) - positions_2(t,:)).^2));
    
    if min_distance > distance
      min_distance = distance;
      nearest_time = t;
    end
    
    pause(1/60);
  end
  
  display(['Min distance ', num2str(min_distance), ' at ', num2str(nearest_time)]);
end
