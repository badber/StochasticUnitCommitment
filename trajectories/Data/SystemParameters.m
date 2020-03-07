clearvars 
clc 

% The units here are GW, k£/GW and k£ to keep the range of variables closer

%%
num_CGGT = 10;
num_OCGT = 5;
num_Clusters = 2;

num_Gen = [num_CGGT num_OCGT];

%% Generation costs:
% (In the form)
% c = [cost_gen1 cost_gen2 cost_gen3...]';
NLHR = [0.54 0.7]'; % k£/h
HRS = [47 500]'; % k£/GWh
stc = [0.5 0.5]'; % k£


%% Capacities and limits:

% Generation limits:
% (In the form)
% Gen_limits = [G1_min, G1_max;
%               G2_min, G2_max;
%               G3_min, G3_max;
%               ...
Gen_limits_CCGT = [0.01; 0.05]';
Gen_limits_OCGT = [0.005; 0.01]';
Gen_limits = [Gen_limits_CCGT;
              Gen_limits_OCGT];
          
% % Ramp limits:
% % (In the form)
% % Ramp_limits = [Ramp_down1, Ramp_up1;
% %                Ramp_down2, Ramp_up2;
% %                Ramp_down3, Ramp_up3;
% %                ...
% Ramp_CCGT = [0.05; 0.05]';
% Ramp_OCGT = [0.02; 0.02]';
% Ramp_limits = [Ramp_CCGT;
%               Ramp_OCGT];
          

%% Other parameters
VOLL = 30e3; % Units: k£/GWh

tau = 1; % 1 hour time step

inflexible = [1 0]; % 1 if unit is inflexible after DA, 0 otherwise


%%
save('SystemParameters.mat')


