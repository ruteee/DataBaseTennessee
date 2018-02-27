function [ dist ] = dist_gen( ts, dist_set )
%DIST_GEN Summary of this function goes here
%   Detailed explanation goes here
    dist = [ts zeros(length(ts), 28)];
    
    if ~isfield(dist_set, 'id') || all(dist_set.id < 1)
        return
    end
    
    for i = 1:length(dist_set.id)
        start_ts = find(ts == dist_set.start(i));
        end_ts = find(ts == dist_set.end(i));
        dist(start_ts:end_ts, dist_set.id(i) + 1) = ones(end_ts - start_ts + 1, 1);
    end
    
end
