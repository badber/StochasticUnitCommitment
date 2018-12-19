% Author: Luis Badesa

%%
clearvars 
clc 

% The units here are GW, k£/GW and k£ to keep the range of variables closer


%% Generation costs:
% (In the form)
% c = [cost_gen1 cost_gen2 cost_gen3...]';
NLHR = [0.54*ones(1,10) 0.3*ones(1,5)]'; % k£/h
HRS = [47*ones(1,10) 200*ones(1,5)]'; % k£/GWh
stc = [1*ones(1,10) 0*ones(1,5)]'; % k£


%% Capacities and limits:

% Generation limits:
% (In the form)
% Gen_limits = [G1_min, G1_max;
%               G2_min, G2_max;
%               G3_min, G3_max;
%               ...
Gen_limits_CCGT = [0.03*ones(1,10); 0.05*ones(1,10)]';
Gen_limits_OCGT = [0.005*ones(1,5); 0.02*ones(1,5)]';
Gen_limits = [Gen_limits_CCGT;
              Gen_limits_OCGT];
          
% Ramp limits:
% (In the form)
% Ramp_limits = [Ramp_down1, Ramp_up1;
%                Ramp_down2, Ramp_up2;
%                Ramp_down3, Ramp_up3;
%                ...
Ramp_CCGT = [0.03*ones(1,10); 0.03*ones(1,10)]';
Ramp_OCGT = [0.02*ones(1,5); 0.02*ones(1,5)]';
Ramp_limits = [Ramp_CCGT;
              Ramp_OCGT];
          

%% Other parameters
VOLL = 30e3; % Units: k£/GWh

tau = 1; % 1 hour time step

inflexible = [ones(1,10) zeros(1,5)]; % 1 if unit is inflexible after DA, 0 otherwise

%Initial_commitment = [zeros(1,15)]';

%% Error checks
num_gen = length(HRS);

% if length(Demand)~=stages
%     error('The length of vector Demand must be equal to the number of stages (the stages come from Coursework2.m)')
% end

% if length(Initial_commitment)~=num_gen
%     error('The lenght of vector "Initial_commitment" must be equal to the number of generators')
% end

if size(Gen_limits,1)~=num_gen
    error('Matrices "Gen_limits" and "Ramp_limits" must have as many rows as generators defined')    
end
if size(Gen_limits,2)~=2
    error('Matrices "Gen_limits" and "Ramp_limits" must only have 2 columns')    
end
if any(size(Gen_limits)~=size(Ramp_limits))
    error('There is a problem with the size of matrix "Gen_limits" or "Ramp_limits"')
end


%%
save('SystemParameters.mat')


