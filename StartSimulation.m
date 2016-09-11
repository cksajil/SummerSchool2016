%% Active Noise Cancellation Algorithm Simulation in a Virtual Room 
% based on the paper "Room acoustics simulation for multichannel microphone
% arrays" A. Wabnitz, N. Epain, C. Jin, and A. van Schaik
% in Proceedings of the International Symposium on Room Acoustics
% Melbourne, Australia, August 2010

%% Room Settings

RoomSize        = [2, 2, 2];
Temperature     = 28;

Room = SetupRoom(                   'Dim',  RoomSize,...
                                    'Temp', Temperature);

%% Error Mic Settings

Receiver1Loc            = [1, 2, 1];   
Receiver1Orientation    = [90,90,90];
Receiver1Type           = 'omnidirectional';

Receivers = AddReceiver([],         'Type',        Receiver1Type,...
                                    'Location',    Receiver1Loc,...
                                    'Orientation', Receiver1Orientation );
                                
%% Noise Source Settings

NoiseSourceLoc          = [1, 1, 1];
NoiseSourceOrientation  = [90,90,90];
NoiseSourceType         = 'omnidirectional';

Sources = AddSource([],         'Type',        NoiseSourceType,...
                                'Location',    NoiseSourceLoc,...
                                'Orientation', NoiseSourceOrientation);
                            
%% Anti Noise Settings

AntiNoiseLoc            = [1, 1.5, 1.5];
AntiNoiseOrientation    = [90, 90, 90];
AntiNoiseType           = 'omnidirectional';
                           
Sources = AddSource(Sources,    'Type',        AntiNoiseType,...
                                'Location',    AntiNoiseLoc,...
                                'Orientation', AntiNoiseOrientation );
                                
%% Set Other Options 

Options = MCRoomSimOptions();

%% Run The Simulation

RIR = RunMCRoomSim(Sources,Receivers,Room,Options);

%% Fetch the Room Impulse Responses

% Here we calculate the Primary and Secondary path Impulse Responses
% from the Virtual Room Model.

%% Calculate the Secondary Propagation Path Impulse Response

H   = RIR{1,2};
H   = H/norm(H);
N   = length(H);
Fs  = Options.Fs;
t   = (1:N)/Fs;

figure(1);
plot(t(1:4000),H(1:4000),'b');
xlabel('Time [sec]');
ylabel('Coefficient value');
title('Secondary Path Impulse Response');
grid on;

%% Calculate The Primary Propagation Path

G = RIR{1,1};
G = G/norm(G);

figure(2);
plot(t,G,'b');
xlabel('Time [sec]');
ylabel('Coefficient value');
title('Primary Path Impulse Response');
grid on;

%% Graphics Section

Nodes = [Receiver1Loc;NoiseSourceLoc;AntiNoiseLoc];

figure(3);
scatter3(Nodes(:,1),Nodes(:,2),Nodes(:,3),'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .75])
xlabel('x axis');xlim([0 RoomSize(1)]);
ylabel('y axis');ylim([0 RoomSize(2)]);
zlabel('z axis');zlim([0 RoomSize(3)]);
title('Transducer Constellation in Room');
% ,...
%     num2str(RoomSize(1)),'*',num2str(RoomSize(2)),...
%     '*',num2str(RoomSize(3)),' meter Room'])

text(Nodes(1,1),Nodes(1,2),Nodes(1,3),'  Error Mic')
text(Nodes(2,1),Nodes(2,2),Nodes(2,3),'  Noise Source')
text(Nodes(3,1),Nodes(3,2),Nodes(3,3),'  Secondary Source')

%% Do the Real Time Analysis with ANCinAction.m


