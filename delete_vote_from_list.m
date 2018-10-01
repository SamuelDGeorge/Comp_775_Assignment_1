function [vote_list] = delete_from_vote_list(vote_list, x_delete, y_delete)
    toRemove = vote_list.location_list_cy_cx == [y_delete, x_delete];
    list_1 = toRemove(:,1);
    list_2 = toRemove(:,2);
    toDelete = [];
    for item = 1:size(list_1)
        same_1 = list_1(item);
        same_2 = list_2(item);
        same = same_1 && same_2 == 1;
        toDelete = [toDelete;same];
    end

    toDelete = logical(toDelete);
    vote_list(toDelete, :) = [];
end