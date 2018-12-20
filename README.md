# StochasticUnitCommitment
Solve the stochastic version of the Unit Commitment, a typical optimisation problem in power systems.

This code solves a **two-stage, multi-period Stochastic Unit Commitment (SUC)**. Two approaches to solving this problem are included:

- The typical approach using time-trajectories to model the uncertainty is included in folder "[trajectories](trajectories/)". For more info on this approach, check book "Decision Making Under Uncertainty in Electricity Markets" by Conejo et al.
- An alternative approach which models uncertainty through a scenario tree is included in folder "[scenario_tree](scenario_tree/)". This approach in inspired by [this paper](https://ieeexplore.ieee.org/document/6026941).

The optimisation problem is solved via the toolbox **YALMIP**, you can find instructions on how to install it [here](https://yalmip.github.io/tutorial/installation/). You will also need to install some external solver like Mosek or Gurobi, both of which have academic licenses available. Remember to also install the Matlab functionalities of that solver.
