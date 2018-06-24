function [q] = energy_imbalance(Temperature,T_old,delta_H,delta_H_old,CVx,CVy,delta_x,delta_y,dt,k,rho,Cp)
% Child function to check unsteady energy balance
del_x = delta_x/2;
q_left = k.*dt.*delta_y.*(Temperature(2:CVy+1,2)-Temperature(2:CVy+1,1))./(del_x);
q_right = -k.*dt.*delta_y.*(Temperature(2:CVy+1,CVy+2)- Temperature(2:CVy+1,CVy+1))./(del_x);
q_abs_1 = rho*delta_x*delta_y*Cp.*(Temperature(2:CVy+1,3:CVx) - T_old(:,2:CVx-1));
q_abs_2 = delta_H(:,2:CVx-1) - delta_H_old(:,2:CVx-1);
q_abs = q_abs_1+q_abs_2;
q = [q_left q_abs(:,:) q_right];
end

