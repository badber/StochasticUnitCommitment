% Author: Luis Badesa

%%
clearvars
clc

%% Inputs
quantiles = [0.01 0.1 0.5 0.9 0.99];
time_steps = 4;

% Wind error:
mu = 0;
sigma = 1;

% AR(1) process:
phi = 1.2;
eps_C = 0.14;

%% 2-stage tree (branching only at root node)
quantiles_flip = flip(quantiles);

% Error in Wind forecast in each node
wind_error(1:length(quantiles_flip),1)=zeros(length(quantiles_flip),1);
for k=2:time_steps
    for n=1:length(quantiles_flip)
        if k==2
            wind_error(n,k) = phi*wind_error(n,k-1)+eps_C*norminv(quantiles_flip(n),mu,sigma);
            % Check "inverse cumulative function" to calculate quantiles_flip
        else
            wind_error(n,k) = phi*wind_error(n,k-1);
        end
    end
end

% Probabilities to reach each node, referred to the root node
prob(1:length(quantiles),1)=zeros(length(quantiles),1);
prob(ceil(length(quantiles)/2),1)=1;
for k=2 % The only node with branches is the 1st one
    for n=1:length(quantiles)
        if n==1
            prob(n,k) = 0.5*(quantiles(2)^2/(quantiles(2)-quantiles(1)));
        elseif n==2
            prob(n,k) = 0.5*(quantiles(3)-quantiles(1)-quantiles(1)^2/(quantiles(2)-quantiles(1)));
        elseif (n>2)&&(n<length(quantiles)-1)
            prob(n,k) = 0.5*(quantiles(n+1)-quantiles(n-1));
        elseif n==length(quantiles)-1
            prob(n,k) = 0.5*(quantiles(end)-quantiles(end-2)-(1-quantiles(end))^2/(quantiles(end)-quantiles(end-1)));
        else
            prob(n,k) = 0.5*((1-quantiles(end-1))^2/(quantiles(end)-quantiles(end-1)));
        end
    end
end
for k=3:time_steps
    prob(:,k) = prob(:,2);
end

clear k n
save('ScenarioTree.mat')
