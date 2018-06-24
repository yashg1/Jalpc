function [energy_TOL,urelax_energy,my_lambda,TOL_energy_imbalance] = solver_tolerance()
%% Energy Equation
energy_TOL = 1e-6; % Solver tolerance
urelax_energy = 0.7; %Under-relaxation for energy equation
my_lambda = [0.01 0.01 0.01 0.01]; % Under-relaxation factor for enthalpy update
TOL_energy_imbalance = 1e-5; % Tolerance for unsteady energy balance
end

