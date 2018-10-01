function [generated_image] = image_generator(disk_radius, log_image_size, list_of_intensities, num_disks, image_position_range, blur_level, noise_intensity)
   starting_image = 255  * ones(2^log_image_size, 2^log_image_size, 'uint8');
   starting_image = im2double(starting_image);

    for i = 1:num_disks
     x_random = randi(image_position_range);
     y_random = randi(image_position_range);
     opacity = datasample(list_of_intensities,1);
     starting_image = insertShape(starting_image,'FilledCircle',[x_random, y_random, disk_radius], 'color', {'blue'}, 'opacity', opacity(1));
    end

    starting_image = imgaussfilt(starting_image, blur_level);
    starting_image = imnoise(starting_image, 'gaussian', noise_intensity);

    imshow(starting_image)
    generated_image = starting_image;
end