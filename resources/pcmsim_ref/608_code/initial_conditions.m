function [delta_H,delta_H_old,lfrac,initial_state,initial_Temperature,...
    u,v,p] = initial_conditions(CVx,CVy,latent_heat,b_conditions,T_initial)
%% Initialize nodal latent heats -> indicates initial state (solid/liquid)
%%
%%--------------------> 0 - solid ; latent_heat - liquid <-----------------
initial_state = 0; 
%%
%Set nodal latent heat values according to initial state
delta_H_old = ones([CVy,CVx]).*initial_state;
delta_H = delta_H_old; %set initial value for t=0
if(initial_state == latent_heat)
    lfrac = ones([CVy,CVx]);
else
    lfrac = zeros([CVy,CVx]);
end

%% Extract Boundary Conditions
%%
Tb_left = b_conditions(1,1); Tb_right = b_conditions(1,2);
qb_top = b_conditions(1,3); qb_bottom = b_conditions(1,4);
%%  Dummy rows, columns added to show boundary temperatures------%
%%
initial_Temperature= ones([CVy+2,CVx+2]).*T_initial;
initial_Temperature(:,1) = Tb_left;
initial_Temperature(:,CVx+2) = Tb_right;

%% MOMENTUM EQUATIONS
%% %% Velocities
%%
u = ones([CVy,CVx+1])*1e-4;v = ones([CVy+1,CVx])*1e-4;p = ones([CVy,CVx])*0;
u(:,CVx+1)=0;u(:,1)=0;v(CVy+1,:)=0;v(1,:)=0;
end

