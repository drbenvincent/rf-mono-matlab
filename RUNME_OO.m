%% Run this code to use the object oriented implimentation


addpath('funcsOO')

clear classes, clear all

% create a dataset object
imagedata = dataset('DATA.mat')


%% Run a simulation with synaptic costs
synapse_cost        = 0.01;
firing_rate_cost    = 0;
num_neurons         = 64;
% create a network object
net1 = network(num_neurons,...
	synapse_cost,...
	firing_rate_cost,...
	imagedata.input_image_size);
% run many learning iterations
for n=1:50000, net1 = net1.learn(imagedata); end


%% Run a simulation with firing rate costs
synapse_cost        = 0;
firing_rate_cost    = 0.2;
num_neurons         = 324;
% create a network object
net2 = network(num_neurons,...
	synapse_cost,...
	firing_rate_cost,...
	imagedata.input_image_size);
% run many learning iterations
for n=1:50000, net2 = net2.learn(imagedata); end