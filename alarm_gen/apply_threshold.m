function [ low, high ] = apply_threshold( sim_out, low_threshold, high_threshold )
%APPLY_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

    low = sim_out < low_threshold;
    high = high_threshold < sim_out;

end

