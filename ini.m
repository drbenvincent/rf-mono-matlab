function [net, IMAGES]=ini(numhid,SYNAPSE_COST,RATE_COST)
% Simply sets up the neural network and some parameters
%
%
%
% =============== THIS CODE WAS WRITTEN BY BENJAMIN VINCENT ===============
% IF YOU DO ANYTHING COOL WITH THIS CODE, FEEL FREE TO EMAIL ME AT:
% B.T.VINCENT@DUNDEE.AC.UK
%
% IF YOU USE IT, PLEASE CITE THE FOLLOWING WORK:
%
% - Vincent B, Troscianko T, Gilchrist I, (2007) Investigating a
% space-variant weighted salience account of visual selection,
% Vision Research, 47(13): 1809-1820.
%
% - Vincent B, Baddeley R, Troscianko T, Gilchrist I, (2005) Is the early
% visual system optimised to be energy efficient, Network: Computation in 
% Neural Systems, 16(2/3): 175-190.
% =========================================================================



figure(1),clf,colormap(gray)
figure(2),clf,colormap(gray)

load DATA

input_image_size    =size(IMAGES,1);

% ======================================================
% Initialise network
net.numin   =input_image_size;
net.numhid  =numhid;
net.wcon	=0;	% weight decay parameter

% Create Gaussian distributed random weights
net.w      =(randn(net.numhid,net.numin)*0.1);
%net.w=generate_correlated_random_patches( sqrt(net.numin), net.numhid);

% DEFINE OTHER THINGS
net.lr				=0.004;
net.display			=1;
net.SYNAPSE_COST    =SYNAPSE_COST;
net.RATE_COST       =RATE_COST;
net.batch_size		=100;
net.lr_schedule		=1;
net.epoch			=1;

% Set L2 of each filter to 1
[net]				=set_l2_to_1(net);

% parameters to play around with, but these work just fine
net.lr					=0.002; % learning rate
net.display_interval	=1000;	% just determines how frequency of replotting 

% plot the initial random receptive fields
see_matrix(net.w);
drawnow

fprintf('\nTraining model: %d %1.3f %1.3f\n',net.numhid,net.SYNAPSE_COST,net.RATE_COST)

