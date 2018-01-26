function [ low, high ] = apply_threshold( process, low_threshold, high_threshold )
%APPLY_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    
    tout = process.tout;
    sim_out = process.simout;

    low.state = sim_out < low_threshold;
    high.state = high_threshold < sim_out;
    
    low.state = [low.state(1,:), ;diff(low.state)];
    high.state = [high.state(1,:), ;diff(high.state)];
    
    [low.time, low.var] = find(low.state);
    [high.time, high.var] = find(high.state);
    
    low.state = low.state(low.time + (low.var-1) * size(low.state, 1));
    high.state = high.state(high.time + (high.var - 1) * size(high.state, 1));
    
    low.time = tout(low.time);
    low.var = low.var;
    
    high.time = tout(high.time);
    high.var = high.var;

end

