function [end_time,delta_t,timesteps,b_conditions,zone,T_initial] = time_bc_details(CVx,CVy)
%Time Step Details + BC + Initial Conditions
%% ---------------------------TIME STEPPING DETAILS----------------------%
%%
end_time = 20; %time in s
delta_t = 0.05; %---dt---
timesteps = end_time/delta_t; % No.of Time-steps -- NOTE--
%% -----------------------------BOUNDARY CONDITIONS-----------------------%
%% ENERGY EQUATION
%% 
T_initial = 28.3;
Tb_left = 38; %in degC
Tb_right = 28.3;
qb_top = 0; %in W/m^2
qb_bottom = 0;
b_conditions = [Tb_left Tb_right qb_top qb_bottom]; %Array of BC's
%% MOMETUM EQUATION
%%

%% ----Identify interior,boundary, edge nodes and label corresponding CV--%
%%
[zone] = create_zones(CVx,CVy);
end

