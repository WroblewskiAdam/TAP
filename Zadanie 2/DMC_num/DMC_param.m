clear;
load("odpowiedzi_skokowe_Tp25.mat")

D = 300;
N = 300; Nu = 10; lambda = 5;

nu = 2 ; % l wejść
ny = 2; % l wyjść

E = 0;

s = odpowiedzi;

S = cell(1, D);
for i=1:D
    S_temp = zeros(ny, nu);
    for y=1:ny
        for u=1:nu
            S_temp(y, u) = s{y}{u}(i);
        end
    end
    S{i} = S_temp;
end
    
M = cell(ny*N, nu*Nu);
for row =1:N
    for column = 1:Nu
        SS = zeros(ny,nu);
        if row - column + 1 > 1
            SS = S{row - column + 1};
            M{row,column} = SS;
        else
            M{row,column} = SS;
        end
    end
end

M = cell2mat(M);

Mp = cell(ny*N, nu*(D-1));
for column=1:(D-1)
    for row=1:N
        if row + column > D
            Mp{row, column} = S{D} - S{D-1};
        else
            Mp{row, column} = S{row + column} - S{column};
        end
    end
end
Mp = cell2mat(Mp);

I = eye(nu*Nu);
L = eye(nu*Nu)*lambda;
J = tril(ones(nu*Nu));