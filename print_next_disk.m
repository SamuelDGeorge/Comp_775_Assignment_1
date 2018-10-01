function [new_accumulator, vote_list, returned_image] = print_next_disk(image_file, disk_radius, accumulator, vote_list)
maximum = max(max(accumulator));
[y_max,x_max] = find(accumulator==maximum);
returned_image = insertShape(image_file,'FilledCircle',[x_max, y_max, disk_radius], 'color', {'black'}, 'opacity', 1);
[new_accumulator, vote_list] = delete_local_max(accumulator, vote_list, x_max, y_max, disk_radius);
imshow(returned_image)

end