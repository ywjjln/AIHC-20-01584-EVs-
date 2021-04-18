function B=car_load(M)
%本程序基于蒙特卡洛思想生成6500台充电汽车充电负荷曲线

% M=500; %6500辆车
N=3000; %3000次模拟
r=0;
Bh=zeros(M,24);%24小时

for k=1:N
    for i=1:M   %对6500辆车依次模拟
    Ph=zeros(24,1);
    r=r+1;
    T_start=get_start(); %充电开始时间随机数
    mileage=get_mileage();  %每日行驶里程随机数
    P_hi=3.6;%充电功率
    T_charge=round(0.139*mileage/P_hi);  %计算充电时长=行驶里程*每公里耗电量/充电功率
    T_sum=T_start+T_charge; %充电结束时间
    if T_sum>=24 && T_sum<=28 %将随机数大于24的保留部分补至次日凌晨
        new_T_sum=T_sum-24;
        Ph(T_start:24)=P_hi;
        Ph(1:new_T_sum)=P_hi;
    elseif T_sum<24 && T_sum>=0
        Ph(T_start:T_sum)=P_hi;
    end
    for i=1:24      %该辆车24小时充电情况，充电时充电功率为3.6kW，未充电时为0
        Bh(r,i)=Ph(i);
    end
end
B=sum(Bh,1);    %24小时各时段充电负荷
beta=std(B)/(sqrt(M)*mean(B));
if beta<0.05
    break
end
end
    
% plot(B,'k');
% % axis([0 24 0 2500]);
% xlabel('时间(h)');
% ylabel('充电功率(kW)');
% title('电动汽车充电负荷曲线');
% set(gcf,'color',[1 1 1]);   %将图形窗口底色设为白色
% set(gca,'xtick',0:24);  %去掉x轴的刻度  
