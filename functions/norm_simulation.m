function [ process ] = norm_simulation( process )
%NORM_SIMULATION Summary of this function goes here
%   Detailed explanation goes here

    process = (process - min(process)) ./ (max(process) - min(process));
    
end

