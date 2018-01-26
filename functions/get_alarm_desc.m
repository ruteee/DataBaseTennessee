function [ alarm ] = get_alarm_desc( low, high )
%GET_ALARM_DESC Summary of this function goes here
%   Detailed explanation goes here

    alarm = [repmat("LOW", 1, length(low)), repmat("HIGH", 1, length(high))]';
    
end

