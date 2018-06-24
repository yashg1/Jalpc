function [ustar,vstar,p]=ProjectSimpleProgram(u,v,p,T,lfrac,dt,uold,vold)
%% Calls the simple algorithm for a natural convection process
% Nx=Nodes in the x direction
% Ny=Nodes in the y direction
% lfrac=liquid fraction

%% Input constants
[l,w,CVx,CVy,rho,rho_ref,betta,~,T_melt,~,mu,~,g,~] = material_prop;
[dx,dy,~,~,~,~,~,~,~,~] = mesh_gen(CVx,CVy,l,w);
alpha=0.5;
Nx=CVx;
Ny=CVy;
%% Initializing
%%
ppnew = zeros([Ny,Nx]);
ustar = zeros([Ny,Nx+1]);
uprime = zeros([Ny,Nx+1]);
vstar = zeros([Ny+1,Nx]);
vprime = zeros([Ny+1,Nx]);
%% Find T face values
Tavg=zeros(Ny+1,Nx);
for i=1:Nx+1
Tavg(Ny+1,i)=T(Ny,i);
Tavg(1,i)=T(1,i);
end

epsu=zeros(Ny,Nx+1);
epsv=zeros(Ny+1,Nx);
% lfrac=delta_H/latent_heat;
% if lfrac<0
%     lfrac=0;
% elseif lfrac>1
%     lfrac=1;
% end
    
    
for i=1:Nx
    for j=2:Ny
        Tavg(j,i)=(T(j,i)+T(j-1,i))/2;
        epsv(j-1,i)=lfrac(j-1,i);
        epsu(j-1,i)=lfrac(j-1,i);
    end
end
epsv(Ny+1,:)=epsv(Ny,:);
%% Input initial guess matrix
for i=1:Nx
    for j=1:Ny
        ppnew(j,i)=1;
    end
end 
for i=1:Nx+1
    for j=1:Ny
        ustar(j,i)=u(j,i);
        uprime(j,i)=0;
    end
end 
for i=1:Nx
    for j=1:Ny+1
        vstar(j,i)=v(j,i);
        vprime(j,i)=0;
    end
end 
% uold=ustar;
% vold=vstar;
% 
% ppnew(Ny,:)=0;
% ppnew(:,Nx)=0;
iter=0;
%% Setup SIMPLE while loop
bP=ones(Ny,Nx);
while max(max(abs(ppnew)))>0.001
    u=ustar;
    v=vstar;
    iter=iter+1;
    pp=ppnew;
%% Setup a value matrix
awu=zeros(Ny,Nx-1);aeu=awu;anu=awu;asu=awu;bu=awu;apu0=awu;
awv=zeros(Ny-1,Nx);aev=awv;anv=awv;asv=awv;bv=awv;apv0=awv;

for i=1:Nx+1
    for j=1:Ny
        awu(j,i)=mu*dy/dx;
        aeu(j,i)=mu*dy/dx;
        anu(j,i)=mu*dx/dy;
        asu(j,i)=mu*dx/dy;
%         apu0(j,i)=rho*dy*dx/dt;
        apu0(j,i)=rho*dx*dy/dt;
        Au(j,i)= -160000*power((1-epsu(j,i)),2)./(power(epsu(j,i),3)+0.001);
        %Au(j,i)=0;
    end
end
for i=1:Nx-1
    for j=1:Ny
        bu(j,i+1)=dy*(p(j,i)-p(j,i+1));
    end
end
bu(:,1)=0;
bu(:,Nx+1)=0;
for i=1:Nx
    for j=1:Ny+1
        awv(j,i)=mu*dy/dx;
        aev(j,i)=mu*dy/dx;
        anv(j,i)=mu*dx/dy;
        asv(j,i)=mu*dx/dy;
%         apv0(j,i)=rho*dy*dx/dt;
        apv0(j,i)=rho*dx*dy/dt;
        Av(j,i)= -160000*power((1-epsv(j,i)),2)./(power(epsv(j,i),3)+0.001);
        %Av(j,i)=0;
    end
end
bv=zeros(Ny+1,Nx);
for i=1:Nx
    for j=1:Ny-1
        bv(j+1,i)=dx*dy*rho_ref*betta*g*(Tavg(j+1,i)-T_melt)+dx*(p(j,i)-p(j+1,i));
    end
end
bv(1,:)=0;
bv(Ny+1,:)=0;
%% Setup boundary conditions for COLM


apu=(anu+asu+awu+aeu-Au*dx*dy+apu0);
apv=(anv+asv+awv+aev-Av*dx*dy+apv0);

[ustar,apup]=lblTDMA(apu,aeu,awu,asu,anu,bu,Au,u,uold,apu0,rho,mu,dx,dy,1);
[vstar,apvp]=lblTDMA(apv,aev,awv,asv,anv,bv,Av,v,vold,apv0,rho,mu,dx,dy,2);

contour(vstar)
%% Setup pressure correction from COM

aE=zeros(Ny,Nx);aN=aE;aS=aE;aW=aE;app0=zeros(Ny,Nx);
anu=ones(Ny,Nx+1)*mu*dx/dy;
asu=anu;aeu=anu;awu=anu;
anv=ones(Ny+1,Nx)*mu*dx/dy;
asv=anv;aev=anv;awv=anv;

for i=1:Nx
    for j=1:Ny
        aE(j,i)=rho*dy/apup(j,i+1);
        aW(j,i)=rho*dy/apup(j,i);
        aN(j,i)=rho*dx/apvp(j+1,i);
        aS(j,i)=rho*dx/apvp(j,i);
        bP(j,i)=rho*(dy*(ustar(j,i)-ustar(j,i+1))+dx*(vstar(j,i)-vstar(j+1,i)));
    end
end
%aE(:,Nx)=0;aW(:,1)=0;aN(Ny,:)=0;aS(1,:)=0;
aP=aE+aW+aN+aS;
ppnew=lblTDMApressure(aP,aE,aW,aS,aN,bP,pp,app0);
%ppnew(Ny,Nx)=0;
p=p+alpha*ppnew;

if iter==100
    break
else
    continue
end



end
conv=max(max(abs(ppnew)));
fprintf('Velocity: iteration=%d  Convergence=%f\n',iter,conv);
% figure(1)
% contour(vstar)
% figure(2)
% contour(ustar)
% figure(3)
% x=1:Ny;
% plot(x,ustar(:,Nx/2));
% fprintf('Iteration=%d\n',i);
% fprintf('Ustar=\n');
% disp(ustar);
% fprintf('Vstar=\n');
% disp(vstar);
% fprintf('Pressure=\n');
% disp(p);
