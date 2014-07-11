% RUNME.m

addpath('funcs')

%% Run a simulation with synaptic costs

% define parameters
synapse_cost        = 0.01; 
firing_rate_cost    = 0; 
num_neurons         = 64; 

% initialise the network
[net, IMAGES] = ini(num_neurons,synapse_cost,firing_rate_cost);

% run many learning iterations
for n=1:50000, [net]=learn(net,IMAGES); end

% save it
save('synapse_costs.mat','net')


%% Run a simulation with firing rate costs

clear

% define parameters
synapse_cost        = 0; 
firing_rate_cost    = 0.2; 
num_neurons         = 324; 

% initialise the network
[net, IMAGES] = ini(num_neurons,synapse_cost,firing_rate_cost);

% run many learning iterations
for n=1:50000, [net]=learn(net,IMAGES); end

% save it
save('firing_rate_costs.mat','net')
