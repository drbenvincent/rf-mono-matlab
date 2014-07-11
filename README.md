# rf-mono-matlab


This repo contains Matlab code to calculate energy efficient receptive fields to encode a dataset of images. Before this code made its way onto GitHub, then it appeared on my lab website [here](http://www.inferencelab.com/energy-efficient-receptive-field-code/).

This minimal set of MATLAB functions will set up a simple neural network to learn receptive fields. These receptive fields minimise an energy function which involves a) image patch reconstruction error, b) sum of absolute firing rates, c) sum of absolute synaptic strengths. We haven’t done this explicitly, but this can be interpreted within a Bayesian framework where the constraints on synapses and firing rates represent some prior distribution over parameters.

Included in `DATA.mat` is a sample of nearly 50,000 16×16 pixel image patches which were randomly sampled from the van Hateren image database (which doesn’t seem to be available online any more, but are possibly mirrored elsewhere). You can of course make your own set of image samples, and the code will work with whatever size image patches you give it. Although it assumes the image patches are square.

## Cite us

This code is a minimum working example of the code used in these papers. If you use this code, please cite both these papers. Thanks!

* Vincent B, Baddeley R, Troscianko T, Gilchrist I, (2005) Is the early visual system optimised to be energy efficient, Network: Computation in Neural Systems, 16(2/3): 175-190.

* Vincent B & Baddeley R, (2003) Synaptic energy efficiency in retinal processing, Vision Research 43:1283-1290.

## To Do list...

* a Python version, in a new repo.

## File overview
We actually have two implementations here, which do the same thing. The first is coded in standard Matlab, using procedural programming. The second (added July 2014) is implemented using Object Oriented Programming. These two implementations are entirely separate, and I just did it as part of learning how to do OOP.

### Standard implementation

Run `RUNME.m` and it uses the functions in `/funcs`

### Object oriented implementation

Run `RUNME_OO.m` and it uses the objects in `/funcsOO`

## Instructions

* Download the MATLAB code and the image patch dataset and place in a folder.
* Set the MATLAB path to that folder
* Run the code in `RUNME.m`. This will run 2 simulations, firstly with a synapse constraint, secondly with a firing rate constraint. The results should look similar to the plots below.

![](http://www.inferencelab.com/wp-content/uploads/rfplot.png)
![](http://www.inferencelab.com/wp-content/uploads/v1.png)

**Notes**

* I would recommend starting with costs on EITHER synapses OR firing rates. These parameters amount to a dimensionless constraint, so a value of zero means unconstrained.
* The image patches are 16×16, so there are a total of 256 input pixels. So if you want to examine under-complete codes, then set `num_neurons` to any value under 256. Likewise for over-complete codes set it to any value above 256.
* From our (me and Roland Baddeley’s) research, if you want something that looks like biological reality, then synaptic costs seem to be relevant in the retinal (under-complete) and firing rates seem to be relevant in V1 (over-complete) codes.
* This code trains the network using gradient descent, which is not the fastest method, however the code is as minimal (and hopefully understandable) as possible. You will have to run for a lot of iterations before you approach the global minimum, and you might have to manually decrease `net.lr` when the receptive fields look like they have begun to converge. If the receptive fields are changing too much or are unstable, then also decrease `net.lr`.

