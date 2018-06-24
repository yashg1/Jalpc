function [iter,iter_uns_energy,ap,an,as,aw,ae,ab,b,...
    F_e,F_w,F_n,F_s,D_e,D_w,D_n,D_s,D_b,u,v,...
    Temperature,T_current,delta_H,delta_H_old,q] = energy_eqn_solver(initial_Temperature,T_old,delta_H_old,b_source,ap0,time,end_time,u,v)
% Check T_old , u, v
% Dont update values from initial conditions
%%
%------------------------SOLVE ENERGY EQUATION----------------------------%

%% -------------------Extract Material Props------------------------------%
%%
[l,w,CVx,CVy,rho,~,~,k,T_melt,Cp,~,latent_heat,~,~] = material_prop();
%% -----------------------Extract grid data-------------------------------%
%%
[x_increment,y_increment,xface,yface,xx,yy,~,~,~,~] = mesh_gen(CVx,CVy,l,w);
%% ----------------------Extract Time steps data -------------------------%
[~,delta_t,~,b_conditions,~] = time_bc_details(CVx,CVy);
%% ----------------------Extract Tolerance/Convergence Criteria-----------%
[energy_TOL,urelax_energy,my_lambda,TOL_energy_imbalance] = solver_tolerance();
%% -----------------Compute Under-rleaxation for enthalpy update----------%
if(time <= end_time/20)
    lambda = my_lambda(1);
elseif(time > end_time/20 && time < end_time/10);
    lambda = my_lambda(2);
elseif(time >=end_time/10 && time <end_time/3);
    lambda = my_lambda(3);
else
    lambda = my_lambda(4);
end
%% ---------------------------DISCRETIZE-----------------------------%%
%%
[ap,an,as,aw,ae,ab,b,...
    F_e,F_w,F_n,F_s,D_e,D_w,D_n,D_s,D_b,u,v] =...
    discretize_ept_uds_vel(b_conditions,T_old,b_source,ap0,...
    CVx,CVy,xface,yface,xx,yy,k,rho,u,v);
%% ----------------------------CALL SOLVER------------------------------%%
%%
time;
%Temperature is a (CVy+2,CVx+2) sized array
[Temperature,delta_H,iter] = solve_energy(initial_Temperature,urelax_energy,...
    ap,an,as,ae,aw,b,ap0,delta_H_old,CVx,CVy,energy_TOL,Cp,lambda,...
    T_melt,latent_heat);
iter;

T_current = Temperature(2:CVy+1,2:CVx+1);
%% -------------------Computing unsteady energy balance------------------%%
%%
[q,iter_uns_energy] = uns_energy_conv(Temperature,T_old,delta_H,delta_H_old,...
    CVx,CVy,TOL_energy_imbalance,x_increment,y_increment,delta_t,k,rho,Cp);
end

