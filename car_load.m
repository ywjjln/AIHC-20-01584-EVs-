function B=car_load(M)
%������������ؿ���˼������6500̨���������縺������

% M=500; %6500����
N=3000; %3000��ģ��
r=0;
Bh=zeros(M,24);%24Сʱ

for k=1:N
    for i=1:M   %��6500��������ģ��
    Ph=zeros(24,1);
    r=r+1;
    T_start=get_start(); %��翪ʼʱ�������
    mileage=get_mileage();  %ÿ����ʻ��������
    P_hi=3.6;%��繦��
    T_charge=round(0.139*mileage/P_hi);  %������ʱ��=��ʻ���*ÿ����ĵ���/��繦��
    T_sum=T_start+T_charge; %������ʱ��
    if T_sum>=24 && T_sum<=28 %�����������24�ı������ֲ��������賿
        new_T_sum=T_sum-24;
        Ph(T_start:24)=P_hi;
        Ph(1:new_T_sum)=P_hi;
    elseif T_sum<24 && T_sum>=0
        Ph(T_start:T_sum)=P_hi;
    end
    for i=1:24      %������24Сʱ�����������ʱ��繦��Ϊ3.6kW��δ���ʱΪ0
        Bh(r,i)=Ph(i);
    end
end
B=sum(Bh,1);    %24Сʱ��ʱ�γ�縺��
beta=std(B)/(sqrt(M)*mean(B));
if beta<0.05
    break
end
end
    
% plot(B,'k');
% % axis([0 24 0 2500]);
% xlabel('ʱ��(h)');
% ylabel('��繦��(kW)');
% title('�綯������縺������');
% set(gcf,'color',[1 1 1]);   %��ͼ�δ��ڵ�ɫ��Ϊ��ɫ
% set(gca,'xtick',0:24);  %ȥ��x��Ŀ̶�  
