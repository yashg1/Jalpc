function u = tdma(a,b,c,d,N)
%TDMA 
% a(i) = b(i)T(i+1)+c(i)T(i-1)+d(i) 
% a denoted diag index = 0 , b=1 , c=-1, d = RHS , N= gridpoints
% T(i) = P(i)T(i+1)+Q(i) -> Recursion used

%Start with P(1),Q(1)
P = zeros([1,N]); % row vector
Q = zeros([1,N]); % row vector
u = zeros([1,N]); % row vector
P(1) = b(1)./a(1);
Q(1) = d(1)./a(1);

for i = 2:N
    P(i) = b(i)./(a(i) - (c(i).*P(i-1)));
    Q(i) = (d(i)+(c(i).*Q(i-1)))./(a(i) - (c(i).*P(i-1)));
end
u(N) = Q(N); 
%Back substitution
for i = N-1:-1:1 %Check
    u(i) = (P(i).*u(i+1))+Q(i);
end
% fprintf('P')
% disp(P);
% fprintf('Q')
% disp(Q);
% fprintf('\n')
end
