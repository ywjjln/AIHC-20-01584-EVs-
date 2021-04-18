clear;
Max_Dt=300;%����������200
D=72;%�����ռ�ά����δ֪��������
N=100;%���Ӹ���100
w_max=0.9;
w_min=0.4;
v_max=2;
BTmax=500;BTmin=0;
s=1;
global PV
global grid_price
global electricity_demand
global PV_flage
global load_33_sum
global position
global CT
global gama
global pload44

load  pload44
pload44=pload44/4;
CT=40000;
gama=0.5;
load PV
load grid_price
electricity_demand=24000; %�綯�����������
PV_flage=1; % �Ƿ�ӹ�� 1 �� 0 ����
load_33_sum=37150; % 33�ڵ��ܸ���
position=[26 27 28 18]; %ǰ�����ǵ綯���������λ��  ���һ���ǹ����λ��
% lamta_1=1;
% lamta_2=1;
% lamta_3=1;
% lamta_4=1;
% lamta_5=1;
% lamta_6=1;
for i=1:N
    for j=1:D
        v(i,j)=0.0;
        x(i,j)=BTmin+rand()*(BTmax-BTmin);
    end
          
end    


    
%����������ӵ���Ӧ�ȣ�����ʼ��Pi��Pg****************
for i=1:N
    p(i)=fitness11(x(i,:),s);
    y(i,:)=x(i,:);%ÿ�����ӵĸ���Ѱ��ֵ
end
Pbest=fitness11(x(1,:),s);
pg=x(1,:);%PgΪȫ������
for i=2:N
    if fitness11(x(i,:),s)<fitness11(pg,s)
       Pbest=fitness11(x(i,:),s);
       pg=x(i,:);%ȫ�����Ÿ���
    end
end



%������ѭ��*****************************************
for t=1:Max_Dt
    
    for i=1:N
        w=w_max-(w_max-w_min)*t/Max_Dt;%����Ȩ�ظ���
        c1=(0.5-2.5)*t/Max_Dt+2.5; %��֪
        c2=(2.5-0.5)*t/Max_Dt+0.5; %�����ʶ   
       
        v(i,:)=w*v(i,:)+c1*rand()*(y(i,:)-x(i,:))+c2*rand()*(pg-x(i,:));
        for m=1:D
            if(v(i,m)>v_max)
                v(i,m)=v_max;
            elseif(v(i,m)<-v_max)
                v(i,m)=-v_max;
            end
        end
        
        x(i,:)=x(i,:)+v(i,:);
        %�����ӱ߽紦��*****************************
        for n=1:D
                   if x(i,n)>BTmax
                         x(i,n)=BTmax;
                         v(i,n)=-v(i,n); 
                   elseif x(i,n)<BTmin
                         x(i,n)=BTmin;
                         v(i,n)=-v(i,n); 
                   
                   end
         
        
        end
     
        %�����ӽ������ۣ�Ѱ������ֵ******************
        if fitness11(x(i,:),t)<p(i)
            p(i)=fitness11(x(i,:),t);
            y(i,:)=x(i,:);
        end
        if p(i)<Pbest
            Pbest=p(i);
            pg=y(i,:);
            s=t;
        end
      
    end
    figure(1)
    uu(t)= Pbest;
    plot(uu,'-ro');
 title('Ŀ�꺯����������ͼ');
 xlabel('��������');
 ylabel('Ŀ�꺯����С');
 grid on
end 


 car_1=pg(1:24);  % ��ȡ�������վ�ĳ��ƻ�
car_2=pg(25:48);
car_3=pg(49:72);

    figure(2);

bar( car_1,'b');
 title('���վ1���мƻ�');
 xlabel('ʱ��');
 ylabel('����/kw');
 grid on
     figure(3);

bar( car_2,'b');
 title('���վ1���мƻ�');
 xlabel('ʱ��');
 ylabel('����/kw');
 grid on
     figure(4);

bar( car_3,'b');
 title('���վ1���мƻ�');
 xlabel('ʱ��');
 ylabel('����/kw');
 grid on
  
 F=zeros(6,1); %Ŀ�꺯������
 for i=1:24
    P_load(i)= car_1(i)+car_2(i)+car_3(i)+4*pload44(i); %���ɼӵ綯�����ĸ���
    F(6)= F(6)+(car_1(i)+car_2(i)+car_3(i))*grid_price(i); % ����*���=������
    fai(i)=(1-P_load(i)/(0.95*CT));
 end
 
F(1)=max(P_load);
F(2)=max(P_load)-min(P_load);
F(3)=std(P_load);

for i=1:24
      [V_flu,Ploss ,V_amp]=powerflow(car_1(i),car_2(i),car_3(i),PV(i),pload44(i));  %������г�������
      V_flu_24(i)=V_flu;
      Ploss_24(i)=Ploss;
      V_amp_24(i,:)=V_amp';
   
end
F(4)=sum(V_flu_24);
F(5)=sum(Ploss_24);
    figure(6);
plot(P_load);
 title('���ɱ仯����','-db');
 xlabel('ʱ��');
 ylabel('����/kw');
 grid on
 
    figure(10);
plot( Ploss_24,'-db');
 title('����仯����');
 xlabel('ʱ��');
 ylabel('����/kw');
 grid on
 
 
time_flage=12;
figure(7)
plot(  V_amp_24(time_flage,:),'-*r');
xlabel('�ڵ���')
ylabel('��ѹ��ֵ')

