function [ap,an,as,aw,ae,ab,b,...
    F_e,F_w,F_n,F_s,D_e,D_w,D_n,D_s,D_b,u,v] =...
    discretize_ept_uds_vel(b_condition,T_old,b_source,ap0,...
    CVx,CVy,xface,yface,xx,yy,k,rho,u,v)
%% DIFFUSION/CONVECTION and ISOTHERMAL PHASE CHANGE ONLY with UPWINDING
%%
%Discretization scheme for Neumann BC on top and bottom with source terms according to
%Fully Implicit time stepping
%Flux in positive X,Y direction -> Cartesian
%% -------------------------INITIALZING-----------------------------------%
%%
%% Convective terms
F_e = zeros([CVy,CVx]);F_w = zeros([CVy,CVx]);F_n = zeros([CVy,CVx]);F_s = zeros([CVy,CVx]);
f_correction = zeros([CVy,CVx]);
%F_b = zeros([CVy,CVx]); % Geometric BC
%% Diffusive Terms
%%
D_e = zeros([CVy,CVx]);D_w = zeros([CVy,CVx]);D_n = zeros([CVy,CVx]);D_s = zeros([CVy,CVx]);
D_b = zeros([CVy,CVx]);
%% a terms
%%
ap = zeros([CVy,CVx]);aw = zeros([CVy,CVx]);ae = zeros([CVy,CVx]);
an = zeros([CVy,CVx]);as = zeros([CVy,CVx]);ab =  zeros([CVy,CVx]);
a_sum = zeros([CVy,CVx]);
b = zeros([CVy,CVx]);
%% Extract Boundary Conditions
%%
Tb_left = b_condition(1,1); Tb_right = b_condition(1,2);
qb_top = b_condition(1,3); qb_bottom = b_condition(1,4);
%% Velocities
%%
%u = zeros([CVy,CVx+1]);v = zeros([CVy+1,CVx]);
%u(2:CVy-1,2:CVx) = 0;
%v(2:CVy,2:CVx-1) = 0;
%u = @(x)(0);%(power(x,2)+1); %calculate "u" velocity (x) component
%v = @(y)(0);%(power(y,2)+2); %calculate "v" velocity (y) component
%%
%%%%------CHECK SIGNS FOR FLUX ; SINCE AREA VECTORS ARE ALWAYS OUTWARD AND
%%%%FLUX IS IN POSITIVE X, Y (Cartesian)
%Geometric BC all
%%
%% -------------------------------INTERIOR--------------------------------%
%%
for i=2:(CVy-1)
    for j=2:(CVx-1)
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_w = abs(xx(i,j)-xx(i,j-1)); %Note that j-1 = west
        del_e = abs(xx(i,j+1)-xx(i,j)); %Note that j+1 = east
        del_n = abs(yy(i,j)-yy(i-1,j)); %Note that i-1 = north
        del_s = abs(yy(i+1,j)-yy(i,j)); %Note that i+1 = south
        %% Convective terms
        %%
        F_e(i,j) = rho.*u(i,j+1).*delta_y;
        F_w(i,j) = rho.*u(i,j).*delta_y;
        F_n(i,j) = rho.*v(i,j).*delta_x;
        F_s(i,j) = rho.*v(i+1,j).*delta_x;
        f_correction(i,j) = +F_e(i,j)-F_w(i,j)+F_n(i,j)-F_s(i,j);
        %% Diffusive Terms
        %%
        D_e(i,j) = k.*delta_y./del_e;
        D_w(i,j) = k.*delta_y./del_w;
        D_n(i,j) = k.*delta_x./del_n;
        D_s(i,j) = k.*delta_x./del_s;
        %% a = F + D - max out
        %%
        aw(i,j) = max(F_w(i,j),0) + D_w(i,j);
        ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        as(i,j) = max(F_s(i,j),0) + D_s(i,j);
        a_sum(i,j) = aw(i,j)+ae(i,j)+an(i,j)+as(i,j); %Sum of nearest neighbours
        ap(i,j) = a_sum(i,j) + ap0(i,j) + f_correction(i,j);
        %% b term
        %%
        b(i,j) = (ap0(i,j).*T_old(i,j))+ b_source(i,j);
    end
end
%% ---------------------------------TOP-----------------------------------%
%%
for j=2:CVx-1
    i=1;
    delta_y = abs(yface(i+1,j)-yface(i,j));
    delta_x = abs(xface(i,j+1)-xface(i,j));
    del_w = abs(xx(i,j)-xx(i,j-1));
    del_e = abs(xx(i,j+1)-xx(i,j));
    del_s = abs(yy(i+1,j)-yy(i,j));
    %% Convective Terms
    %%
    F_e(i,j) = rho.*u(i,j+1).*delta_y;
    F_w(i,j) = rho.*u(i,j).*delta_y;
    %F_b(i,j) = rho*v(yy(i,j)+(delta_y./2))*delta_x;
    F_s(i,j) = rho.*v(i+1,j).*delta_x;
    f_correction(i,j) = +F_e(i,j)-F_w(i,j)-F_s(i,j);%+F_b(i,j) % Geometric BC
    %% Diffusive Terms
    %%
    D_e(i,j) = k.*delta_y./del_e;
    D_w(i,j) = k.*delta_y./del_w;
    D_s(i,j) = k.*delta_x./del_s;
    %% a terms - F + D %% Max out
    %%
    aw(i,j) = max(F_w(i,j),0) + D_w(i,j);
    ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
    as(i,j) = max(F_s(i,j),0) + D_s(i,j);
    a_sum(i,j) = aw(i,j)+ae(i,j)+as(i,j); %w-e-b-s
    ap(i,j) = a_sum(i,j)+ap0(i,j)+f_correction(i,j);
    %% b term
    %%
    b(i,j) = (ap0(i,j).*T_old(i,j)) - (qb_top.*delta_x) + b_source(i,j); %note "-" in b_flux
end
%% -------------------------------BOTTOM----------------------------------%
%%
for j=2:CVx-1
    for i=CVy
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_w = abs(xx(i,j)-xx(i,j-1));
        del_e = abs(xx(i,j+1)-xx(i,j));
        del_n = abs(yy(i,j)-yy(i-1,j));%Note that i-1 = north
        %% Convective Terms
        %%
        F_e(i,j) = rho.*u(i,j+1).*delta_y;
        F_w(i,j) = rho.*u(i,j).*delta_y;
        F_n(i,j) = rho.*v(i,j).*delta_x;
        %F_b(i,j) = rho*v(yy(i,j)-(delta_y./2))*delta_x;
        f_correction(i,j) = +F_e(i,j)-F_w(i,j)+F_n(i,j);%-F_b(i,j) % Geometric BC
        %% Diffusive Terms
        %%
        D_w(i,j) = k.*delta_y./del_w;
        D_e(i,j) = k.*delta_y./del_e;
        D_n(i,j) = k.*delta_x./del_n;
        %% a terms - F + D %% Max out
        %%
        aw(i,j) = max(F_w(i,j),0) + D_w(i,j);
        ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        a_sum(i,j) = aw(i,j)+ae(i,j)+an(i,j);%w-e-b-n
        ap(i,j) = a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b term
        %%
        b(i,j) = (ap0(i,j).*T_old(i,j)) + (qb_bottom.*delta_x) + b_source(i,j);
    end
end
%% ----------------------------LEFT---------------------------------------%
%%
for i=2:CVy-1
    for j=1
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_e = abs(xx(i,j+1)-xx(i,j));
        del_n = abs(yy(i,j)-yy(i-1,j));%Note that i-1 = north
        del_s = abs(yy(i+1,j)-yy(i,j));
        del_b = abs(xx(i,j) - xface(i,j));
        %% Convective terms
        %%
        F_e(i,j) = rho.*u(i,j+1).*delta_y;
        F_n(i,j) = rho.*v(i,j).*delta_x;
        F_s(i,j) = rho.*v(i+1,j).*delta_x;
        %F_b(i,j) = rho*u(xx(i,j)-(delta_x./2))*delta_y;
        f_correction(i,j) = +F_e(i,j)+F_n(i,j)-F_s(i,j);%-F_b(i,j) %Geometric BC
    %% Diffusive Terms
    %%
        D_e(i,j) = k.*delta_y./del_e;
        D_n(i,j) = k.*delta_x./del_n;
        D_s(i,j) = k.*delta_x./del_s;
        D_b(i,j) = k.*delta_y./del_b;
        %% a terms - F+D - max out
        %%
        ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        as(i,j) = max(F_s(i,j),0) + D_s(i,j);
        ab(i,j) = D_b(i,j); %Geometric BC
        a_sum(i,j) = as(i,j)+ae(i,j)+an(i,j)+ab(i,j);%b-e-n-s
        ap(i,j) = a_sum(i,j)+ap0(i,j)+ f_correction(i,j);
        %% b terms
        %%
        b(i,j) = (ap0(i,j).*T_old(i,j))+ (ab(i,j).*Tb_left) + b_source(i,j); %Note Last 2 terms ->Check
    end
end
%% -------------------------------RIGHT-----------------------------------%
%%
for i=2:CVy-1
    for j=CVx
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_w = abs(xx(i,j)-xx(i,j-1));
        del_n = abs(yy(i,j)-yy(i-1,j));
        del_s = abs(yy(i+1,j)-yy(i,j));
        del_b = abs(xface(i,j+1)-xx(i,j));
        %% Convective terms
        %%
        %F_b(i,j) = rho.*u(xx(i,j)+(delta_x./2)).*delta_y;
        F_w(i,j) = rho*u(i,j).*delta_y;
        F_n(i,j) = rho*v(i,j).*delta_x;
        F_s(i,j) = rho*v(i+1,j)*delta_x;
        f_correction(i,j) = -F_w(i,j)+F_n(i,j)-F_s(i,j);%F_b(i,j) %Geometric BC
        %% Diffusive terms
        %%
        D_w(i,j) = k.*delta_y./del_w;
        D_n(i,j) = k.*delta_x./del_n;
        D_s(i,j) = k.*delta_x./del_s;
        D_b(i,j) = k.*delta_y./del_b;
        %% a terms
        %%
        aw(i,j) = max(F_w(i,j),0) + D_w(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        as(i,j) = max(F_s(i,j),0) + D_s(i,j);
        ab(i,j) = D_b(i,j); %Geometric BC
        a_sum(i,j) = as(i,j)+aw(i,j)+an(i,j)+ab(i,j);%w-b-n-s
        ap(i,j) = a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b terms
        %%
        b(i,j) = (ap0(i,j).*T_old(i,j))+(ab(i,j).*Tb_right)+ b_source(i,j);
    end
end
%%
 %%---------------------CORNER NODES DISCRETIZATION----------------------%%

%% ----------------------------LEFT TOP-----------------------------------
%%
for i=1
    for j=1
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_s = abs(yy(i+1,j)-yy(i,j));
        del_e = abs(xx(i,j+1)-xx(i,j));
        del_b_w = abs(xx(i,j) - xface(i,j));
        %% Convective Terms
        %%
        F_e(i,j) = rho.*u(i,j+1).*delta_y;
        F_s(i,j) = rho*v(i+1,j)*delta_x;
        f_correction(i,j) = F_e(i,j)-F_s(i,j);
        %% Diffusive Terms
        %%
        D_s(i,j) = k.*delta_x./del_s;%No west
        D_e(i,j) = k.*delta_y./del_e; %No north
        Db_w = k.*delta_y./del_b_w; %No west
        D_b(i,j) = Db_w;
        %% a terms - max out
        %%
        ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
        as(i,j) = max(F_s(i,j),0) + D_s(i,j);
        ab(i,j) = D_b(i,j);% Geometric BC      
        a_sum(i,j) = as(i,j)+ae(i,j)+ab(i,j);%b-e-b-s
        ap(i,j) =  a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b terms
        %%
        b_left_top = Db_w.*Tb_left - qb_top.*delta_x; %->Check
        b(i,j) = (ap0(i,j).*T_old(i,j))+ b_left_top + b_source(i,j);
    end
end
%% -----------------------------RIGHT TOP---------------------------------
%%
for i=1
    for j=CVx
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_s = abs(yy(i+1,j)-yy(i,j));%No north
        del_w = abs(xx(i,j)-xx(i,j-1));%No east-adj
        del_b_e = abs(xface(i,j+1)-xx(i,j));
        %% Convective Terms
        %%
        F_w(i,j) = rho*u(i,j)*delta_y;
        F_s(i,j) = rho*v(i+1,j)*delta_x;
        f_correction(i,j) = -F_w(i,j)-F_s(i,j);
        %% Diffusive Terms
        %%
        D_s(i,j) = k.*delta_x./del_s;
        D_w(i,j) = k.*delta_y./del_w;
        Db_e = k.*delta_y./del_b_e; %No east-adj
        D_b(i,j) = Db_e;
        %% a Terms - max out
        %%
        aw(i,j) = max(F_w(i,j),0) + D_s(i,j);
        as(i,j) = max(F_s(i,j),0) + D_w(i,j);
        ab(i,j) = D_b(i,j); %Geometric BC
        a_sum(i,j) = as(i,j)+aw(i,j)+ab(i,j);%w-b-b-s ->Check
        ap(i,j) = a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b terms
        %%
        b_right_top =  (Db_e.*Tb_right)- qb_top.*delta_x;
        b(i,j) = (ap0(i,j).*T_old(i,j)) + b_right_top + b_source(i,j);
    end
end
%% -----------------------------LEFT BOTTOM-------------------------------
%%
for i=CVy
    for j=1
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_n = abs(yy(i,j)-yy(i-1,j));
        del_e = abs(xx(i,j+1)-xx(i,j));
        del_b_w = abs(xx(i,j) - xface(i,j));
        %% Convective Terms
        %%
        F_e(i,j) = rho.*u(i,j+1).*delta_y;
        F_n(i,j) = rho*v(i,j)*delta_x;
        f_correction(i,j) = F_e(i,j)+F_n(i,j);
        %% Diffusive Terms
        %%
        D_n(i,j) = k.*delta_x./del_n;%No south-adj
        D_e(i,j) = k.*delta_y./del_e;%No west
        Db_w = k.*delta_y./del_b_w; %No west
        D_b(i,j) = Db_w; %Geometric BC
        %% a terms - max out
        %%
        ae(i,j) = max(-F_e(i,j),0) + D_e(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        ab(i,j) = D_b(i,j); %Geometric BC
        a_sum(i,j) = an(i,j)+ae(i,j)+ab(i,j);%b-n-e-b
        ap(i,j) =  a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b terms
        %%
        b_left_bottom = Db_w.*Tb_left +qb_bottom.*delta_x;
        b(i,j) = (ap0(i,j).*T_old(i,j)) + b_left_bottom + b_source(i,j);
    end
end
%% --------------------------RIGHT BOTTOM---------------------------------
%%
for i=CVy
    for j=CVx
        delta_y = abs(yface(i+1,j)-yface(i,j));
        delta_x = abs(xface(i,j+1)-xface(i,j));
        del_n = abs(yy(i,j)-yy(i-1,j));
        del_w = abs(xx(i,j)-xx(i,j-1));
        del_b_e = abs(xface(i,j+1)-xx(i,j));
        %% Convective Terms
        %%
        F_w(i,j) = rho*u(i,j)*delta_y;
        F_n(i,j) = rho*v(i,j)*delta_x;
        f_correction(i,j) = -F_w(i,j)+F_n(i,j);
        %% Diffusive terms
        %%
        D_n(i,j) = k.*delta_x./del_n;%No south-adj
        D_w(i,j) = k.*delta_y./del_w;%No east-adj
        Db_e = k.*delta_y./del_b_e; %No east-adj
        D_b(i,j) = Db_e;
        %% a terms - F+D - max out
        %%
        aw(i,j) = max(F_w(i,j),0) + D_w(i,j);
        an(i,j) = max(-F_n(i,j),0) + D_n(i,j);
        ab(i,j) = D_b(i,j); %Geometric BC
        a_sum(i,j) = an(i,j)+aw(i,j)+ab(i,j);%b-n-e-b
        ap(i,j) = a_sum(i,j)+ap0(i,j)+f_correction(i,j);
        %% b terms
        %%
        b_right_bottom = (Db_e.*Tb_right) + qb_bottom.*delta_x;
        b(i,j) = (ap0(i,j).*T_old(i,j))+ b_right_bottom + b_source(i,j); %Note Last 2 terms
    end
end
end
