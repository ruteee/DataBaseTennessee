function [ state_str ] = get_state( state )
%GET_STATE Summary of this function goes here
%   Detailed explanation goes here

    state_str(state > 0) = "ALM";
    state_str(state < 0) = "RTN";
    state_str = state_str';
end

