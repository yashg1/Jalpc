function [ap0,b_source] = source_term_energy(xface,yface,CVx,CVy,delta_H_old,delta_H,rho,Cp,dt)
% Source term for energy equation
ap0 = zeros([CVy,CVx]);b_source = zeros([CVy,CVx]);
for i=1:CVy
    for j = 1:CVx
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        ap0(i,j) = rho.*Cp.*delta_x.*delta_y./dt; %Note Volume of cell
        %% Note divide by Cp -> check
        %
        b_source(i,j) = ap0(i,j).*(delta_H_old(i,j)-delta_H(i,j))./Cp; 
    end
end
end

