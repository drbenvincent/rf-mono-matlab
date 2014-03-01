% RUNME.m

% initialise the network 
synapse_cost = 0.005; % try around 0.03 for starters 
firing_rate_cost = 0; % try around 0.2 for starters 
num_neurons = 64; 
% initialise the network
[net, IMAGES] = ini(num_neurons,synapse_cost,firing_rate_cost);
% run many learning iterations
for n=1:50000, [net]=learn(net,IMAGES); end