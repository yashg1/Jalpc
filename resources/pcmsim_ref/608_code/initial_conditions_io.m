function [delta_H,delta_H_old,lfrac,initial_state,initial_Temperature,...
    u,v,p] = initial_conditions_io(CVx,CVy,latent_heat,b_conditions)
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
fileID_temp = fopen('temp.txt','r');
size_temp = [CVy+2 CVx+2];
initial_Temperature = fscanf(fileID_temp,'%f %f \n',size_temp);
fclose(fileID_temp);

%% MOMENTUM EQUATIONS
%% %% Velocities
%% U
%%
fileID_u = fopen('u.txt','r');
size_u = [CVy CVx+1];
u = fscanf(fileID_u,'%f %f \n',size_u);
fclose(fileID_u);
%% V
%%
fileID_v = fopen('v.txt','r');
size_v = [CVy+1 CVx];
v= fscanf(fileID_v,'%f %f \n',size_v);
fclose(fileID_v);
%% P
%%
fileID_p = fopen('p.txt','r');
size_p = [CVy CVx];
p = fscanf(fileID_p,'%f %f \n',size_p);
fclose(fileID_p);
end

