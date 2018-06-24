function [l,w,CVx,CVy,rho,rho_ref,beta,k,T_melt,Cp,mu,latent_heat,g,Pr] = material_prop()
% All Geometric and Material Properties listed here
%   Detailed explanation goes here
%% Cavity Dimensions and control volumes
%%
l = 8.89e-2; %length in m
w = 6.35e-2; %width in m
CVx = [10];
CVy = [10];
%%
rho = 6093; %density in kg/m^3
rho_ref = 6095;
beta = 1.2e-4; %Volumetric thermal expansion coefficient
k = 32; %in W/m C
T_melt = 29.78; %Phase change temperature in C
Cp = 381.5; %specific heat in J/kg*K
mu = 1.81e-3; %Dynamic Viscosity in kg/(m.s)
latent_heat = 80160; %latent heat in J/kg
%%
g = 9.8; % m/s^2
Pr = 2.16e-2; %Prandtl Number
end

