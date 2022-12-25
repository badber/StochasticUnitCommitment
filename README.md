# StochasticUnitCommitment
Solve the stochastic version of the Unit Commitment, a typical optimisation problem in power systems.

This code solves a **two-stage, multi-period Stochastic Unit Commitment (SUC)**. Two approaches to solving this problem are included:

- The typical approach using time-trajectories to model the uncertainty is included in folder "[trajectories](trajectories/)". For more info on this approach, check book "Decision Making Under Uncertainty in Electricity Markets" by Conejo et al.
- An alternative approach which models uncertainty through a scenario tree is included in folder "[scenario_tree](scenario_tree/)". This approach is inspired by [this paper](https://ieeexplore.ieee.org/document/6026941).

The optimisation problem is solved via the toolbox **YALMIP**, you can find instructions for how to install it [here](https://yalmip.github.io/tutorial/installation/). You will also need to install some external solver like Mosek or Gurobi, both of which have academic licenses available. Remember to also install the Matlab functionalities of that solver.

YALMIP is very easy to use. Once installed, you can learn how to use it with file "simple_EconomicDispatch_YALMIP.m", contained in this repository, and through the documentation available in YALMIP's website.

This code has been tested with MATLAB version 2017b.

----

If you use this code for your own work, please cite this paper:
 <ol>
  <li>  S. Camal, F. Teng, A. Michiorri, G. Kariniotakis and L. Badesa, "<b>Scenario generation of aggregated Wind, Photovoltaics and small Hydro production for power systems applications</b>," <i>Applied Energy</i>, vol. 242, pp. 1396-1406, 2019. 
</ol> 
