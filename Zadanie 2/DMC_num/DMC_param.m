clear;
load("odp_skok_Tp10.mat")

D = 100;
N = 50;
Nu = 50;
lambda = 1;

E = 0;

S = odpowiedz_skokowa(:,:,1:D);

[ny, nu, D] = size(S);
    
M=zeros(N*ny, Nu*nu);
for i=1:N
   M((i-1)*ny+1:(i-1)*ny+ny, 1:nu) = S(:, :,min(i, D)); 
end
for i=2:Nu
   M(:, (i-1)*nu+1:(i-1)*nu+nu) = [zeros((i-1)*ny, nu); M(1:(N-i+1)*ny,1:nu)];
end
 
Mp=zeros(ny*N, nu*(D-1));
  
for i=1:D-1
   for j=1:N
      Mp((j-1)*ny+1:j*ny,(i-1)*nu+1:i*nu)=S(:,:,min(i+j,D))-S(:,:,i);
   end
end

L = eye(nu*Nu)*lambda;
I = eye(nu);
J = zeros(nu*Nu, nu*Nu);
J(1:2:Nu*nu, 1:2:Nu*nu) = 1;
J(2:2:Nu*nu, 2:2:Nu*nu) = 1;
J = tril(J);