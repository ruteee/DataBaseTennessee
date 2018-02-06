function [ unnorm_threshold ] = unnorm_threshold( norm_threshold, process )
%NORM_SIMULATION Summary of this function goes here
%   Detailed explanation goes here

    unnorm_threshold = norm_threshold .* (max(process) - min(process)) + min(process);
    
end

