function [u,delta_H,iter] = solve_energy(guess_value,urelax,...
    my_ap,my_an,my_as,my_ae,my_aw,my_b,my_ap0,delta_H_old,my_CVx,my_CVy,my_TOL,...
    Cp,lambda,T_ref,latent_heat)
%% Call from main_energy side
%%
%  [Temperature,delta_H,iter] = solve_energy(initial_Temperature,urelax,...
%     ap,an,as,ae,aw,b,ap0,delta_H_old,CVx,CVy,TOL,Cp,lambda,T_ref,latent_heat);
%%
%Call solvers for energy equation and update latent heats, under-relax
%equations
%  Line by Line TDMA code inside the while loop to capture every iteration
error = 1;
iter =0;
u = guess_value;
while error> my_TOL
    iter = iter + 1;
    uold = u;
    % Solver Sweeps along rows and columns and solve using TDMA
    [u] = solver_sweeps(u,my_ap,my_an,my_as,my_ae,my_aw,my_b,my_CVx,my_CVy);
    %Update Nodal Latent heat at each iteration
    % u is a (CVy+2,CVx+2) sized array
    u_update = u(2:my_CVy+1,2:my_CVx+1);
    [delta_H] = enthalpy_update_iter(u_update,delta_H_old,my_ap,my_ap0,Cp,lambda,T_ref,...
        latent_heat,my_CVx,my_CVy);
    error= max(max(abs((uold-u)./u)));
    % hold on
    % subplot(3,2,4),plot(iter,error,'k*'),title('Iter vs error'),xlabel('iter'),ylabel('error')
    %Under-relax
    u = uold + urelax.*(u-uold); 
end
end
