% Author: Luis Badesa

%%
clearvars
clc

%% Inputs
load('ScenarioTree.mat')

Demand = [215 200 250 220];
VOLL = 100;

Wind_forecast = [36 43 48 35];
Wind_capacity = 75;

num_gen = 3; % Number of generators

% Marginal costs and startup costs:
% (In the form)
% c = [cost1 cost2 cost3...]';
c = [10 15 30]';
stc = [10e3 5e3 1e3]';

% Generation limits:
% (In the form)
% Gen_limits = [G1_min, G1_max;
%               G2_min, G2_max;
%               G3_min, G3_max;
%               ...
Gen_limits = [30 100;
              20 90;
              0 80];
          
% Ramp limits:
% (In the form)
% Ramp_limits = [Ramp_down1, Ramp_up1;
%                Ramp_down2, Ramp_up2;
%                Ramp_down3, Ramp_up3;
%                ...
Ramp_limits = [40 40;
               40 40;
               60 60];

Initial_commitment = [1 1 0]';

tau = 1; % 1 hour time step

%%
if length(Demand)~=length(Wind_forecast)
    error('The length of vectors Demand and Wind_forecast must be equal')
end
if length(Demand)~=stages
    error('The length of vector Demand must be equal to the number of stages (the stages come from Coursework2.m)')
end

%%  
Wind_tree = [];
for k=1:stages
    Wind_tree = [Wind_tree Wind_forecast(k)*(1+wind_error(:,k))];
end
% Check that no value is greater than the wind capacity:
Wind_tree(Wind_tree>Wind_capacity) = Wind_capacity;

Load_balance = [];
Aux_constraints = [];
Constraints_Gen_limits = [];
Constraints_Ramp_limits = [];
for k=1:stages
    for n=1:length(quantiles_flip)
        x{n,k} = sdpvar(num_gen,1);
        % x = [x1 x2 x3...]'; % Power generated by each Gen.
        
        y{n,k} = binvar(num_gen,1);
        % y = [y1 y2 y3...]'; % Commitment decision for each Gen.
        if k==1
            Aux_constraints = [Aux_constraints,...
                               y{n,k}==Initial_commitment];
        end
        
        startup_DV{n,k} = sdpvar(num_gen,1);
        if k==1
            Aux_constraints = [Aux_constraints,...
                               startup_DV{n,k} == y{n,k}];
        else
            Aux_constraints = [Aux_constraints,...
                               startup_DV{n,k} >= y{n,k} - y{n,k-1},...
                               startup_DV{n,k} >= 0];
        end

        Wind_curtailed(n,k) = sdpvar(1);
        Load_curtailed(n,k) = sdpvar(1);
        
        Cost_node(n,k) = stc'*startup_DV{n,k} + tau*(c'*x{n,k}+VOLL*Load_curtailed(n,k));
        
        % Constraints:
        Load_balance = [Load_balance,...
            sum(x{n,k})+Wind_tree(n,k)-Wind_curtailed(n,k) == Demand(k)-Load_curtailed(n,k)];
        
        Aux_constraints = [Aux_constraints,...
                           0 <= Wind_curtailed(n,k) <= Wind_tree(n,k),...
                           0 <= Load_curtailed(n,k) <= Demand(k)];
        
        for i=1:num_gen
            Constraints_Gen_limits = [Constraints_Gen_limits,...
                                      y{n,k}(i)*Gen_limits(i,1) <= x{n,k}(i) <= y{n,k}(i)*Gen_limits(i,2)];
        end
        
        if k==2
            for i=1:num_gen
                Constraints_Ramp_limits = [Constraints_Ramp_limits,...
                                           -tau*Ramp_limits(i,1)*y{n,k-1}(i) <= x{n,k}(i)-x{ceil(length(quantiles)/2),k-1}(i) <= tau*Ramp_limits(i,2)*y{n,k-1}(i)];
            end
        elseif k>2
            for i=1:num_gen
                Constraints_Ramp_limits = [Constraints_Ramp_limits,...
                                           -tau*Ramp_limits(i,1)*y{n,k-1}(i) <= x{n,k}(i)-x{n,k-1}(i) <= tau*Ramp_limits(i,2)*y{n,k-1}(i)];
            end
        end
    end
end


Objective = sum(sum(prob.*Cost_node));
          
Constraints = [Aux_constraints,...
               Load_balance,...
               Constraints_Gen_limits
               Constraints_Ramp_limits];
           
options = sdpsettings('solver','gurobi','gurobi.MIPGap',0.1e-2);

sol = optimize(Constraints,Objective,options)


          