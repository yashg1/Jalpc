clc;close all;clear all

%Solver 2D convection / diffusion phase change with initial temperature Ti
%Aim is to determine melt front propogation
%---------------------<< ENTHALPY-POROSITY METHOD >>----------------------%
% Solving for ENTHALPY as independent variable (H)
% Primary Variable ->  H = h (sensible) + delta_H (latent)
% with H ; S_H = 0 ?????
% phi -> h = C*T
%convectivr term coeff -> none
%transient term coef -> rho ;
%diffusive term coef -> k
% source term -> d(rho*delta_H)/dt

%rectangular cavity with prescribed temperatures on sides

%% ----------------------Geometric and Material Props---------------------%
%%
[l,w,CVx,CVy,rho,rho_ref,beta,k,T_melt,Cp,mu,latent_heat,g,Pr] = material_prop();
T_ref = T_melt;
%% ------------- Mesh Generate ; Arrays for Post Processing---------------%
%%
[x_increment,y_increment,xface,yface,xx,yy,xp,yp,x,y] = mesh_gen(CVx,CVy,l,w);
% Can this be done later???????
%% --------------TIME STEPPING AND BOUNDARY CONDITION DETAILS-------------%
%%
[end_time,delta_t,timesteps,b_conditions,zone,T_initial] = time_bc_details(CVx,CVy);

%% --------------------------INITIAL CONDITIONS---------------------------%
%%
[delta_H,delta_H_old,lfrac,initial_state,initial_Temperature,...
    uint,vint,p] = initial_conditions(CVx,CVy,latent_heat,b_conditions,T_initial);
%%
%intializing T_old which will carry
%forward previous values with initial temperature
T_old = initial_Temperature(2:CVy+1,2:CVx+1);

%% -----------------------CONVERGENCE CRITERIA----------------------------%
%%
[energy_TOL,urelax_energy,my_lambda,TOL_energy_imbalance] = solver_tolerance();

%% ------------------------------TIME LOOP--------------------------------%%
%%
count = 0;
tic
u=uint;
v=vint;
uold=uint;
vold=vint;
Temperature=initial_Temperature;
% -------------------------TIME LOOP STARTS------------------------------- %
for time = 0:delta_t:end_time
    fprintf('\n\nTime=%f\n',time);
    uold=u;
    vold=v;
    %% ------------------------SOURCE TERMS-------------------------------%
    %%
    %-----------------------------ENERGY EQUATION-------------------------%
    [ap0,b_source] = source_term_energy(xface,yface,CVx,CVy,delta_H_old,delta_H,rho,Cp,delta_t);
    delta_H_old = delta_H;
    %%
    % ADD MOMENTUM HERE
    %% Energy Solver call
    %%
%     T_currentiter=T_old;
%     T_current=T_currentiter;
%     T_current(1,1)=T_currentiter(1,1)+.2; %% WHY??
%     tol=1e-3;
%     Titer=0;
    %while max(max(abs(T_current-T_currentiter)))>tol
        %T_currentiter=T_current;
       % Titer=Titer+1;
        %% ------------------------- MOMENTUM EQUATION --------------------------%%
        %%
        [u,v,p]=ProjectSimpleProgram(u,v,p,Temperature,lfrac,delta_t,uold,vold);
        %% --------------------------ENERGY EQUATION -----------------------------%%
        %%
        [iter,iter_uns_energy,ap,an,as,aw,ae,ab,b,...
            F_e,F_w,F_n,F_s,D_e,D_w,D_n,D_s,D_b,u,v,...
            Temperature,T_current,delta_H,delta_H_old,q] = energy_eqn_solver(initial_Temperature,T_old,delta_H_old,...
            b_source,ap0,time,end_time,u,v);
        %% ---------------------------CONVERGENCE CHECK -------------------------%%
        %%
%         conv=max(max(abs(T_current-T_currentiter)));
%         fprintf('Temperature: iteration=%d  Convergence=%f\n',Titer,conv);
%         if Titer==5
%             break
%         else
%             continue
%         end
        
        
    %end
    %conv=max(max(abs(T_current-T_currentiter)));
    %fprintf('Temperature: iteration=%d  Convergence=%f\n',Titer,conv);
    %% ---------------------Set old values------------------------------------
    %%
    T_old = T_current;
    %initial_Temperature = Temperature; ???? CHECK ????
    
    %% -------------------------------PLOT----------------------------------%%
    %%
    %%
    %-----Liquid Fraction-----%
    lfrac = delta_H./latent_heat;
    %figure(1)
    %     hold on
    %     plot(time,lfrac(floor(CVy/2),1),'k*')
    %     hold off
    
end
% ------------------------TIME LOOP ENDS----------------------------------%
%%
toc
%%
%%-------------------------POST PROCESSING------------------------------%%

%%
%% Extract Boundary Conditions
%%
Tb_left = b_conditions(1,1); Tb_right = b_conditions(1,2);
qb_top = b_conditions(1,3); qb_bottom = b_conditions(1,4);
%% Calculating temperatures at faces where flux is prescribed
%%
del_bn = abs(yy(1,1) - yface(1,1));
del_bs = abs(yface(CVy,1) - yy(CVy,1));
Temperature(1,:) = (qb_top+ ((k./del_bn).*Temperature(2,:)))./(k./del_bn);
Temperature(CVy+2,:) = (qb_bottom + ((k./del_bs).*Temperature(CVy+1,:)))./(k./del_bs);
figure(2)
plot(x,Temperature(floor(CVy/2),:),'k*')
ydata = Temperature(floor(CVy/2),:);
% plot_data = [x ydata];
% csvwrite('plot_data_10.dat',plot_data);
title('Temperature variation along horizontal centerline'),xlabel('x'),ylabel('Temperature')
legend(['CV: ',num2str(CVx) ' Time step size: ',num2str(delta_t)])
figure(3)
pcolor(xp,flipud(yp),lfrac),shading interp,
title(' Spatial Variation of Liquid fraction with time'),xlabel('x'),ylabel('y'),colorbar
%legend(['CV:' num2str(CVx)],['time step size:' num2str(delta_t)])
figure(4)
pcolor(x,flipud(y),Temperature),shading interp,
title('Temperature'),xlabel('x'),ylabel('y'),colorbar
%legend(['CV:' '\n Time step size:' num2str(CVx),num2str(delta_t)])
figure(5)
contour(x,flipud(y),Temperature),
title('Temperature'),xlabel('x'),ylabel('y'),colorbar