function xnew=lblTDMApressure(ap,ae,aw,as,an,b,x0,ap0)
%% Function lblTDMA
%  Use TDMA in a line by line form to solve a 2D matrix with QUICK scheme
NJ=length(ap(1,:));
NI=length(ap(:,1));

x=x0;
xnew=x;
xnew(1,1)=x(1,1)+.01;
% TDMA solver: x direction sweep
tol=1e-3;
while max(max(abs(xnew-x)))>tol

    x=xnew;
    for i=1:NI
        for j=1:NJ
            Ap1d(j)=ap(i,j);
            Ae1d(j)=ae(i,j);
            Aw1d(j)=aw(i,j);
            B1d(j)=b(i,j)+ap0(i,j)*x0(i,j);
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
end

