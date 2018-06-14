By: Juncheng Li;
Date: 2018/03/21;
Contact: jlicv@connect.ust.hk;
This document serves as explanation to the implementation progress of the project. If you want to know more about properties of the product, please refer to the final report.

WARNING: Pricer may exhausts RAM available with long maturity(>5yrs). Most of the variables are pre-allocated for optimization.

Part 1 
1.	Implement the model outlined in Section 2;
a.	CholTest_emperical.m: To check if Cholesky factorization can be applied to the correlation matrix. May be executed before using pricer.
b.	CCVS.m: The pricer implemented under local-stochastic volatility model in with Monte Carlo Approach. For convenience, most constant parameters’ values are assigned within the function itself. 
TODO: CCVS pricer with all parameters as input arguments.
2.	Compute the various correlation risk profiles. They will serve as a benchmark for subsequent approaches; They are in the \Risk_Profile folder.
a.	< Corresponding python code>Generate parameter table for further analysis;
b.	CCVS_rho_u1u2_u1x2_corridor_chunks.m: Back up the price with parameters given in the table. 
TODO: add dimensions <U,T> in the table.
c.	Run_CCVS_rho_u1u2_u1x2_corridor_chunks.m: Decide which chunks to be calculated, merge outputs from different chunks into a complete table.
d.	Plot_CCVS_Section2_rhou_1x_2_U_Payoff.m: Plot the curve of CCVS’ price in section2, with different levels of U and rhou_1x_2;
i.	Surface plot with other parameter has been implemented, such piece of code can be accessed upon request.
Part 2 
1.	Implement the model outlined in Section 4 in the case of Gaussian Copula 
a.	VarswapS_1_Curve.m: calibration function for varswap curve on the variance asset, implemented with Monte Carlo approach and the model specified in section2.
b.	S2_digital_marginal.m: calibration function for marginal density of the corridor asset, implemented with Monte Carlo approach and the model specified in section2.
c.	CCVS_gaussian.m: CCVS pricer implemented with Quasi Monte Carlo Method and specifications indicated in Section 4.
2.	Compute the various correlation risk profiles;
a.	Plot_CCVS_gaussian.m: Generate the risk profile of the Price with Gaussian Copula as joint density function, with different values of rhou_1x_2 and levels of Upper bound of the corridor
3.	Conclude regarding the appropriateness of this approach compared to the model of Section 2;
4.	Bonus: Try with different Copulas.
<TOBEDONE>
Part 3 (optional)
1.	Propose some numerical approaches for the model outlined in Section 3;
<TOBEDONE>

Credits:
1.	Yuantao Zhang proposed optimization techniques, error corrections in both section2 and section4’s modelling, as well as the calibration procedure.
2.	Weiyang(David) Wen built up the table for generating risk profiles.
3.	Xuan Huang corrected mistakes in section2’s modelling.

