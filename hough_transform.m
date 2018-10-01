function [final_accumulator, vote_list, image] = hough_transform(image, disk_radius, intensity_polarity, par_stdev, grad_magnitude, sig_mean, sig_stdev, scale, keep_winner)
I2 = rgb2gray(image);
I2 = im2double(I2);
[x_deriv,y_deriv] = Derivative(I2,scale);

%Calculate gradient magnitudes in all directions
[accum_y, accum_x] = size(I2);
magnitude_matrix = zeros(accum_y, accum_x);
current_sum = 0;
counted = 0;

for y = 1:accum_y
    for x = 1:accum_x
        magnitude_matrix(y,x) = sqrt(x_deriv(y,x)^2 + y_deriv(y,x)^2);
        if magnitude_matrix(y,x) > 0
            current_sum = current_sum + magnitude_matrix(y,x);
            counted = counted + 1;
        end
    end
end

%for vote strength
vote_strength = zeros(accum_y, accum_x);

%to collect votes
accumulator = zeros(accum_y, accum_x);

%To build return list
voter_list_py_px = [];
location_list_cy_cx = [];
magnitude_list = [];

for x = 1:accum_x
    for y = 1:accum_y
        %Get vote strength
        vote_strength(y,x) = normcdf(magnitude_matrix(y,x), sig_mean, sig_stdev);
        if vote_strength(y,x) < grad_magnitude
            vote_strength(y,x) = 0;
        end
        
        %Calculate where they should vote
        center = [x,y];
        v_direction = [-x_deriv(y,x), y_deriv(y,x)];
        
        %Adjust for polarity
        if intensity_polarity == 0
            v_direction = -v_direction;
        end
        
        v_magnitude = sqrt(v_direction(1)^2 + v_direction(2)^2);
        new_mag = disk_radius/v_magnitude;
        vote_location = center + (new_mag * v_direction);
        vote_location = round(vote_location);
        
        %If they get a vote, add to accumator and apply appropriate vote
        %strength
        if vote_location(2) > 0 && vote_location(1) > 0 && vote_location(2) < accum_x && vote_location(1) < accum_y && vote_strength(y,x) > 0
            accumulator(vote_location(2), vote_location(1)) = accumulator(vote_location(2), vote_location(1)) + vote_strength(y,x);
            voter_list_py_px = [voter_list_py_px;y,x];
            location_list_cy_cx = [location_list_cy_cx; vote_location(2),vote_location(1)];
            magnitude_list = [magnitude_list;vote_strength(y,x)];
        end  
    end
end



smoothed_accumulator = imgaussfilt(accumulator, par_stdev);
maximum = max(max(smoothed_accumulator));
[y_max,x_max]=find(smoothed_accumulator==maximum);


Final = insertShape(image,'FilledCircle',[x_max(1), y_max(1), disk_radius], 'color', {'black'}, 'opacity', 1);
imshow(Final)

%create final vote list
vote_list = table(voter_list_py_px, location_list_cy_cx, magnitude_list);

if keep_winner == false
   smoothed_accumulator = delete_local_max(smoothed_accumulator, vote_list, x_max, y_max, disk_radius);
end

%Return accumulator
final_accumulator = smoothed_accumulator;
image = Final;

end

