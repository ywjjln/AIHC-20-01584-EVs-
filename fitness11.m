function result=fitness11(x,k)
global electricity_demand
global gama
global load_33_sum
global grid_price
global PV
global CT
global pload44
car_1=x(1:24);  % 提取三个充电站的充电计划
car_2=x(25:48);
car_3=x(49:72);
F=zeros(6,1); %目标函数向量
 for i=1:24
    P_load(i)= load_33_sum+car_1(i)+car_2(i)+car_3(i)+pload44(i)*4; %基荷加电动汽车的负荷
    F(6)= F(6)+(car_1(i)+car_2(i)+car_3(i))*grid_price(i); % 电量*电价=充电费用
    fai(i)=(1-P_load(i)/(0.95*CT));
 end

F(1)=max(P_load);
F(2)=max(P_load)-min(P_load);
F(3)=std(P_load);
global pload44
for i=1:24
    
      [V_flu,Ploss]=IEEE33(car_1(i),car_2(i),car_3(i),PV(i),pload44(i));  %带入进行潮流计算
      V_flu_24(i)=V_flu;
      Ploss_24(i)=Ploss;
   
end
F(4)=sum(V_flu_24);
F(5)=sum(Ploss_24);
car_sum=sum(x);  %充电计划的总和
dd_car=abs(car_sum- electricity_demand);
if dd_car<50
    d=1;
elseif dd_car>50&&dd_car<200
    d=5;
elseif dd_car>200&&dd_car<500
    d=10;
elseif dd_car>500&&dd_car<1000
    d=100;
    elseif dd_car>1000
    d=1000;
end
 object_factor=zeros(6,24);
for i=1:24
    if fai(i)<0
        object_factor(1,i)=1;
        object_factor(6,i)=1;
    elseif fai(i)>0 && fai(i)<gama
        object_factor(1,i)=1;
        object_factor(2,i)=1;
        object_factor(3,i)=1;
        object_factor(4,i)=1;
        object_factor(6,i)=1;
    else fai(i)> gama
         object_factor(5,i)=1;
        object_factor(6,i)=1;
    end
end
F(1)=F(1)/40000;  %归一化
F(2)=F(2)/1000;
F(3)=F(3)/300;
F(4)=F(4)/30;
F(5)=F(5)/4000;
F(6)=F(6)/15000;

for i=1:6
    for j=1:24
   result_24(i,j)= object_factor(i,j)*F(i);
    end
end
% result=F(1)+ 0.0001*d* dd_car; % 优化目标F(1)
% result=F(2)+ 0.0001*d* dd_car; % 优化目标F(2)        
% result=F(3)+ 0.0001*d* dd_car; % 优化目标F(3)
% result=F(4)+ 0.0001*d* dd_car; % 优化目标F(4)
% result=F(5)+ 0.0001*d* dd_car; % 优化目标F(5)
% result=F(6)+ 0.0001*d* dd_car; % 优化目标F(6)
result=sum(sum(result_24))+ 0.0001*d* dd_car; %目标函数加惩罚项

