%DMC------------------------------------------------------------------
function [E, y1, y2, y3, u1, u2, u3, u4, yzad1, yzad2, yzad3]=superDMCmultiverse(wektor, lambda, phi)
    disp(wektor)
%    wektor = [12, 12, 1];
%    lambda = 1;
    Ts=1600; %koniec symulacji
    
    nu = 2;
    ny = 2;
    
    D = 10000;
    start= D+1;
    
    %Definicja horyzontów i parametrów
    N=wektor(1); 
    N_u=wektor(2); 
%     lambda=wektor(3);
%     phi = wektor(3);
    
    s = odpowiedzi_skokowe();
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
    
    %warunki początkowe
    u1(1:Ts)=0; u2(1:Ts)=0; u3(1:Ts)=0; u4(1:Ts)=0;
    y1(1:Ts)=0; y2(1:Ts)=0; y3(1:Ts)=0;
    %skok wartości zadanej
    yzad1(1:400)=0; 
    yzad1(401:800)=-0.5;
    yzad1(801:1200) = 0.5;
    yzad1(1200:Ts) = 2;
    
    yzad2(1:300)=0; 
    yzad2(301:700)=-0.5;
    yzad2(701:1100) = 0.5;
    yzad2(1101:Ts) = 2;
    
    yzad3(1:500)=0; 
    yzad3(501:900)=-0.5;
    yzad3(901:1300) = 0.5;
    yzad3(1301:Ts) = 2;
    
    E=0;

    %Obliczenie części macierzy DMC
    Phi = eye(ny*N)*phi;
    Lambda = eye(nu*N_u)*lambda;


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
    
    K = ((M'*Phi*M+Lambda)^-1)*M'*Phi;

    M_p = cell(ny*N, nu*(D-1));
    for column=1:(D-1)
        for row=1:N
            if row + column > D
                M_p{row, column} = S{D} - S{D-1};
            else
                M_p{row, column} = S{row + column} - S{column};
            end
        end
    end
    M_p = cell2mat(M_p);
    
    for k=start:Ts
        %symulacja obiektu  
        [y1(k),y2(k),y3(k)]=symulacja_obiektu7y_p4(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                                   u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                                   u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                                   u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                                   y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                                   y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                                   y3(k-1),y3(k-2),y3(k-3),y3(k-4));

        %Obliczenie DU_p
        DU_p = [];
        for d=1:(D-1)
            DU_p = cat(1, u1(k-d) - u1(k-d-1), DU_p);
            DU_p = cat(1, u2(k-d) - u2(k-d-1), DU_p);
            DU_p = cat(1, u3(k-d) - u3(k-d-1), DU_p);
            DU_p = cat(1, u4(k-d) - u4(k-d-1), DU_p);
        end

        %Pomiar wyjścia
        Y = ones(ny*N, 1);
        Y(1:ny:end) = y1(k);
        Y(2:ny:end) = y2(k);
        Y(3:ny:end) = y3(k);
        
        %Obliczenie Y_0
        yo = M_p* DU_p + Y;

        Y_zad = ones(ny*N, 1);
        Y_zad(1:ny:end) = yzad1(k);
        Y_zad(2:ny:end) = yzad2(k);
        Y_zad(3:ny:end) = yzad3(k);

        %Obliczenie sterowania
        DU = K * (Y_zad - yo- M_p*DU_p);
        u1(k) = u1(k-1) + DU(1);
        u2(k) = u2(k-1) + DU(2);
        u3(k) = u3(k-1) + DU(3);
        u4(k) = u4(k-1) + DU(4);

        E = E + (yzad1(k)-y1(k))^2;
        E = E + (yzad2(k)-y2(k))^2;
        E = E + (yzad3(k)-y3(k))^2; 
    end
    
% figure(10)
% hold on
% stairs(y1)
% stairs(y2)
% stairs(y3)
% stairs(yzad1)
% legend("wyjście1","wyjście2", "wyjście3", "wartość zadana")
% title("Wyjście")
% figure(11)
% hold on
% stairs(u1)
% stairs(u2)
% stairs(u3)
% stairs(u4)
% legend("Sterowanie1", "Sterowanie2", "Sterowanie3", "Sterowanie4")
% title("Sterowanie")
end