function [accumulator, vote_list] = delete_local_max(accumulator_array, vote_list, x_max, y_max, radius)
min_boarders = imregionalmin(accumulator_array,8);
accumulator_array(y_max, x_max) = 0;
vote_list = delete_from_vote_list(vote_list, x_max, y_max);
current_value = 0;
layer = 1;
y_start = y_max - 1;
x_start = x_max;
accumulator_array(y_start, x_start) = 0;
vote_list = delete_from_vote_list(vote_list, x_start, y_start);

while current_value == 0
    %go right
    for i = 1:layer
        x_start = x_start + 1;
        if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
        end
        current_value = min_boarders(y_start, x_start);
        vote_list = delete_from_vote_list(vote_list, x_start, y_start);
        accumulator_array(y_start, x_start) = 0;
        if current_value == 1
            break
        end
    end
    
    %go up
    for i = 1:(layer * 2)
        y_start = y_start + 1;
        if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
        end
        current_value = min_boarders(y_start, x_start);
        vote_list = delete_from_vote_list(vote_list, x_start, y_start);
        accumulator_array(y_start, x_start) = 0;
        if current_value == 1
            break
        end
    end

    %go left
    for i = 1:(layer * 2)
        x_start = x_start - 1;
        if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
        end
        current_value = min_boarders(y_start, x_start);
        vote_list = delete_from_vote_list(vote_list, x_start, y_start);
        accumulator_array(y_start, x_start) = 0;
        if current_value == 1
            break
        end
    end
    
    %go down
    for i = 1:(layer * 2)
        y_start = y_start - 1;
        if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
        end
        current_value = min_boarders(y_start, x_start);
        vote_list = delete_from_vote_list(vote_list, x_start, y_start);
        accumulator_array(y_start, x_start) = 0;
        if current_value == 1
            break
        end
    end
    
    %go right
    for i = 1:layer
        x_start = x_start + 1;
        if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
        end
        current_value = min_boarders(y_start, x_start);
        vote_list = delete_from_vote_list(vote_list, x_start, y_start);
        accumulator_array(y_start, x_start) = 0;
        if current_value == 1
            break
        end
    end
    y_start = y_start - 1;
    if x_start < 1 || x_start > size(min_boarders, 1) || y_start < 1 || y_start > size(min_boarders, 2)
            break
    end
    accumulator_array(y_start, x_start) = 0;
    vote_list = delete_from_vote_list(vote_list, x_start, y_start);
    layer = layer + 1;
    if layer > radius
        break
    end
    current_value = min_boarders(y_start, x_start);
end
   
accumulator = accumulator_array;
end