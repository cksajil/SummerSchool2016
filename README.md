# SummerSchool2016
My codes for the Joint IEEE SPS and EURASIP Summer School on Robust Signal Processing  Rüdesheim (Rhine), Germany, Sept. 19th-24th 2016




### These codes uses shoebox room acoustic simulation program (MCRoomSim) created by Wabnitz et.al.

Wabnitz, A., Epain, N., Jin, C., & Van Schaik, A. (2010, August). Room acoustics simulation for multichannel microphone arrays. In Proceedings of the International Symposium on Room Acoustics (pp. 1-6). 

Link to MCRoomSim Page [Here](http://www.ee.usyd.edu.au/carlab/mcroomsim.htm)

MCRoomSim helps to find Room Impulse Response(RIRs) between source and receiver in a user defined rectangular shoebox room of given size

####Steps 

1. StartSimulation.m sets the parameters, room size, source and receiver positions (by calling MCRoomSim), and gives RIRs to workspace. plot the RIRs and also plots the transucer constellation 3D plot.

2. ANCInAction.m simulates the ANC experiment, gives out the error signal to workspace and plots it.

3. PSDPlotter.m plots the noise Power Spectral Density(PSD) levels before and after cancellation


