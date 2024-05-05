clear all
close all
load("odpowiedzi_skokowe.mat")

D = 10000; %horyzont dynamiki
N = D; %horyzont predykcji
N_u = D; %horyzont sterowania
lambda = 2; 
phi = 1.5;

nu = 2 ; % l wejść
ny = 2; % l wyjść

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

Phi = eye(ny*N)*phi;
Lambda = eye(nu*N_u)*lambda;
    

% M = zeros(N*ny, N_u*nu);
M = cell(ny*N, nu*N_u);
for row =1:N
    for column = 1:N_u
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
save macierz_M.mat M
% 
% K = ((M'*Phi*M+Lambda)^-1)*M'*Phi;
% save macierz_K.mat K
% 
% 
% K11 = sum(K(1,1:2:N));
% K12 = sum(K(1,2:2:N));
% K21 = sum(K(2,1:2:N));
% K22 = sum(K(2,2:2:N));
% Ke = [K11 K12; K21 K22]
% 
% 
% M_p = cell(ny*N, nu*(D-1));
% for column=1:(D-1)
%     for row=1:N
%         if row + column > D
%             M_p{row, column} = S{D} - S{D-1};
%         else
%             M_p{row, column} = S{row + column} - S{column};
%         end
%     end
% end
% M_p = cell2mat(M_p);
% save macierz_Mp.mat Mp


% % wzorek 30
% Ku = cell(1, D-1);
% Kui = 0;
% deltau = 0;
% for i=1:D-1
%     Ku_ = [K(1,:); K(2,:)];
%     M_p_ = [M_p(:,i) M_p(:,i+2)];
% %     Ku11 = K(1,1:2:N*2)* M_p(1:N,2*i-1:2*i);
% %     Ku12 = K(1,2:2:N*2)* M_p(1:N,2*i-1:2*i);
% %     Ku21 = K(2,1:2:N*2)* M_p(1:N,2*i-1:2*i);
% %     Ku22 = K(2,2:2:N*2)* M_p(1:N,2*i-1:2*i);
% 
% %     M_p11 = M_p(:,2*i-1:2*i);
% %     M_p12 = M_p(:,2*i-1:2*i);
% %     M_p21 = M_p(:,2*i-1:2*i);
% %     M_p22 = M_p(:,2*i-1:2*i);
% 
% %     Kui = [Ku11 Ku12; Ku21 Ku22];
%     Kui = Ku_ * M_p_;
%     Ku{i} = Kui;
% end
% 
% 
% %string format
% % % allOneString = sprintf('%.0f,' , n);
% % % allOneString = allOneString(1:end-1)
% % 
% 
% len = size(Ku);
% len = len(2);
% 
% 
% for i = 1:len
%     inside = Ku{i};
%     C = ['MATRIXKU[', strtrim(num2str(i)), ', ',strtrim(num2str(0)), ']:=', strtrim(num2str(inside(1,1))),  ';\n'];
%     fprintf(C)
% end
% 
% 
% for i = 1:len
%     inside = Ku{i};
%     C = ['MATRIXKU[', strtrim(num2str(i)), ', ',strtrim(num2str(1)), ']:=', strtrim(num2str(inside(1,2))),  ';\n'];
%     fprintf(C)
% end
% 
% for i = 1:len
%     inside = Ku{i};
%     C = ['MATRIXKU[', strtrim(num2str(i)), ', ',strtrim(num2str(2)), ']:=', strtrim(num2str(inside(2,1))),  ';\n'];
%     fprintf(C)
% end
% 
% for i = 1:len
%     inside = Ku{i};
%     C = ['MATRIXKU[', strtrim(num2str(i)), ', ',strtrim(num2str(3)), ']:=', strtrim(num2str(inside(2,2))),  ';\n'];
%     fprintf(C)
% end
% 
% % strjoin(arrayfun(@(x) num2str(x),Ku,'UniformOutput',false),'f, ')
