function [xnew,ap]=lblTDMA(ap,ae,aw,as,an,b,A,x0,xold,ap0,rho,mu,dx,dy,s)
%% Function lblTDMA
%  Use TDMA in a line by line form to solve a 2D matrix with QUICK scheme
NJ=length(ap(1,:));
NI=length(ap(:,1));
fn=zeros(NI,NJ);fs=fn;fe=fn;fw=fn;
x=x0;
xnew=x;
xnew(2,2)=x(2,2)+.1;
alpha=0.6; % Underrelaxation factor
% TDMA solver: x direction sweep
tol=1e-3;
while max(max(abs(xnew-x)))>tol
    
    %% Calculate Flux terms
    % Calculate in and out fluxes

    alpn=zeros(NI,NJ);alps=alpn;alpw=alpn;alpe=alpn;
    x=xnew;
    if s==1;
        for j=1:NJ-1
            xface(:,j)=(x(:,j+1)+x(:,j))/2;
        end
        for j=2:NJ-1
            for i=1:NI
            fe(i,j)=rho*xface(i,j)*dy;
            fw(i,j)=rho*xface(i,j-1)*dy;
            if -fe(i,j-1)>0
                alpe(i,j-1)=1;
            end
            if fw(i,j-1)>0
                alpw(i,j-1)=1;
            end
            end
        end
    elseif s>1;
        for i=1:NI-1
            xface(i,:)=(x(i+1,:)+x(i,:))/2;
        end
        for i=2:NI-1
            for j=1:NJ
            fn(i,j)=rho*xface(i,j)*dx;
            fs(i,j)=rho*xface(i-1,j)*dx;
            if -fn(i-1,j)>0
                alpn(i-1,j)=1;
            end
            if fs(i-1,j)>0
                alps(i-1,j)=1;
            end
            end
        end        
    end
%% Setup new A values
for i=1:NI
    for j=1:NJ
%         ae(i,j)=mu*dy/dx+alpe(i,j)*fe(i,j);
%         aw(i,j)=mu*dy/dx+alpw(i,j)*fw(i,j);
%         an(i,j)=mu*dx/dy+alpn(i,j)*fn(i,j);
%         as(i,j)=mu*dx/dy+alps(i,j)*fs(i,j);
        ae(i,j)=mu*dy/dx-fe(i,j);
        aw(i,j)=mu*dy/dx+fw(i,j);
        an(i,j)=mu*dx/dy-fn(i,j);
        as(i,j)=mu*dx/dy+fs(i,j);

    end
end

%% Setup 0 boundary conditions

for i=1:NI
    for j=1:NJ
    ae(i,NJ)=0;
    ae(i,1)=0;
    aw(i,1)=0;
    aw(i,NJ)=0;
    an(NI,j)=0;
    as(1,j)=0;
    end
end

for i=1:NI
    for j=1:NJ
    ae(i,NJ)=0;
    aw(i,1)=0;
    an(NI,j)=0;
    an(1,j)=0;
    as(1,j)=0;
    as(NI,j)=0;
    end
end
ap=(ae+aw+an+as+(fe-fw+fn-fs)-A);

if s==1
    ap(NI,:)=ap(NI,:)+2*mu*dx/dy;
    ap(1,:)=ap(1,:)+2*mu*dx/dy;
    ap(:,1)=1;
    ap(:,NJ)=1;
elseif s>1
    ap(:,NJ)=ap(:,NJ)+2*mu*dx/dy;
    ap(:,1)=ap(:,1)+2*mu*dx/dy;
    ap(NI,:)=1;
    ap(1,:)=1;
end
    if s==1
    
    for i=1:NI
        for j=1:NJ
            Ap1d(j)=ap(i,j);
            Ae1d(j)=ae(i,j);
            Aw1d(j)=aw(i,j);
            B1d(j)=b(i,j)+ap0(i,j)*xold(i,j);
            if i>1
                B1d(j)=B1d(j)+an(i,j)*x(i-1,j);
            end
            if i<NI
                B1d(j)=B1d(j)+as(i,j)*x(i+1,j);
            end
        end
        x1d=TDMASIMPLE(Ap1d,Ae1d,Aw1d,B1d);
        for k=1:NJ
            xnew(i,k)=x1d(k);
        end
    end
    else
        for j=1:NJ
        for i=1:NI
            Ap1dy(i)=ap(i,j);
            An1dy(i)=an(i,j);
            As1dy(i)=as(i,j);
            B1dy(i)=b(i,j)+ap0(i,j)*xold(i,j);
            if j>1
                B1dy(i)=B1dy(i)+aw(i,j)*x(i,j-1);
            end
            if j<NJ
                B1dy(i)=B1dy(i)+ae(i,j)*x(i,j+1);
            end
        end
        x1dy=TDMASIMPLE(Ap1dy,An1dy,As1dy,B1dy);
        for k=1:NI
            xnew(k,j)=x1dy(k);
        end
    end
    
    end
    xnew=x+alpha*(xnew-x);
    end
end
