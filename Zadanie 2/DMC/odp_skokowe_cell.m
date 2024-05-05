% load("odpowiedzi_skok_Fc.mat")
% load("odpowiedzi_skok_Fh.mat")
% 
% odpowiedzi = cell(2,1);
% odp_y1_h = cell(1,2);
% odp_y2_T = cell(1,2);
% 
% odp_y1_h{1} = odpowiedzi_skok_Fh(:,1);
% odp_y1_h{2} = odpowiedzi_skok_Fc(:,1);
% 
% 
% odp_y2_T{1} = odpowiedzi_skok_Fh(:,2);
% odp_y2_T{2} = odpowiedzi_skok_Fc(:,2);
% 
% odpowiedzi{1} = odp_y1_h;
% odpowiedzi{2} = odp_y2_T;
% save odpowiedzi_skokowe.mat odpowiedzi


load("odpowiedzi_skokowe.mat")
figure(1)
subplot(2,2,1)
stairs(odpowiedzi{1}{1})
title("Skok Fh",'fontsize',10)
ylabel("wyj h",'fontweight','bold','fontsize',10)
set(get(gca,'ylabel'),'rotation',0)


subplot(2,2,2)
stairs(odpowiedzi{1}{2})
title("Skok Fc",'fontsize',10)

subplot(2,2,3)
stairs(odpowiedzi{2}{1})
set(get(gca,'ylabel'),'rotation',0)
ylabel("wyj T",'fontweight','bold','fontsize',10)

subplot(2,2,4)
stairs(odpowiedzi{2}{2})

print("rysunki/odpowiedzi skokowe.png","-dpng","-r800")


% figure(2)
% hold on
% stairs(odpowiedzi{1}{1})
% stairs(odpowiedzi{1}{2})
