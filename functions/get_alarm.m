function [ alarm ] = get_alarm( low, high )
%GET_ALARM Summary of this function goes here
%   Detailed explanation goes here

    alarm = [repmat("LOW", 1, length(low)), repmat("HIGH", 1, length(high))]';

end

