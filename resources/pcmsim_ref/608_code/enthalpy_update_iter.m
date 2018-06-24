function [delta_H] = enthalpy_update_iter(u,delta_H_old,ap,ap0,...
    Cp,lambda,T_ref,latent_heat,my_CVx,my_CVy)
%b_source = zeros([CVy CVx]);
delta_H = zeros([my_CVy,my_CVx]);
%% ---------------------------Updating Enthalpy------------------------%%%
%%
for i=1:my_CVy
    for j = 1:my_CVx
%         if(bcondition(1) > T_ref && bcondition(2) > T_ref && T_initial > T_ref)
%             enthalpy_update_term =0; % Heating liquid
%         elseif (bcondition(1) < T_ref && bcondition(2) < T_ref && T_initial < T_ref)
%             enthalpy_update_term =0; %Cooling solid
%         else
%             enthalpy_update_term = ap(i,j).*Cp.*lambda./ap0(i,j);
%         end
        enthalpy_update_term = ap(i,j).*Cp.*lambda./ap0(i,j);
        delta_H(i,j) = delta_H_old(i,j) + enthalpy_update_term.*(u(i,j) - T_ref);
        %%
        %%Setting bounds
        %%
        if(delta_H(i,j) > latent_heat)
            delta_H(i,j) = latent_heat;
        end
        if(delta_H(i,j)<0)
            delta_H(i,j) = 0;
        end
        %%  ------Update end-------%%%
        %%
        %b_source(i,j) = ap0(i,j).*(delta_H_old(i,j)-delta_H(i,j)); %%%% CHECK SIGNS %%%
    end
end
end

