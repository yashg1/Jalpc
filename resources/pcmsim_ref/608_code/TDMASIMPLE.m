function x=TDMASIMPLE(Ap,ae,aw,B)

%% Function TDMA
%  Solve a triagonal matrix using the TDMA method
%  Program by: Galen Jackson
%aw=[-2 -1 -1 -1];ae=[-1 -1 -1 -2];ap=-aw-ae;b=[500*2 0 0 500*2];
%Ap=ap;
Ae=-ae;
Aw=-aw;
%B=b;
N=length(Ap);
for i=2:N
    r=Aw(i)/Ap(i-1);
    Ap(i)=Ap(i)-r*Ae(i-1);
    B(i)=B(i)-r*B(i-1);
end

x(N)=B(N)/Ap(N);

for i=(N-1):-1:1
    x(i)=(B(i)-Ae(i)*x(i+1))/Ap(i);
end
    