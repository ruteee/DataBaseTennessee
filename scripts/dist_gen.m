function [ dist ] = dist_gen( ts, dist_set)
%DIST_GEN Summary of this function goes here
%   Detailed explanation goes here
    dist = [ts zeros(length(ts), 28)];
    
    if dist_set.id < 1
        return
    end
    
    if dist_set.start >= 0
        start_time = dist_set.start;
    else
        start_time = ts(1);
    end
    
    if dist_set.end >= 0
        end_time = dist_set.end;
    else
        end_time = ts(end);
    end
    
    start_ts = find(ts == start_time);
    end_ts = find(ts == end_time);
    dist(start_ts:end_ts, dist_set.id + 1) = ones(end_ts - start_ts + 1, 1);
end
