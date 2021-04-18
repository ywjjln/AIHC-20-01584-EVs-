%相关原始数据格式说明如下：
%n——节点个数；n1——支路条数；isb——平衡节点号；H——PQ节点个数（为后面形成PVU存储PV节点初始电压用）；pr——误差精度。
%B1——支路参数矩阵，其中第一列和第二列是起始节点编号和终点节点编号,第三列、第四列、第五列、第六列分别为：支路电阻、电抗、变压器变比、电纳。（不考虑电导）
%B2——节点参数矩阵，其中第一列和第二列为节点编号和节点类型；第三列到第六列分别为：注入有功、注入无功、电压幅值、电压相位。
%节点类型分类如下：“0”为平衡节点,“1”为PQ，“2”为PV节点；“3”为PQ（V）节点，“4”为PI节点。
function  [V_flu,Ploss ,V_amp]=powerflow(car_1,car_2,car_3,PV,load4)
n=33 ;       
n=33 ;       
n1=32;
isb=1;
H=32;                %%%%%%%%%%%%%18节点加DG    PQV处理
pr=0.01; 
v_amp=0;
B1=[1 2 0.00922 0.0047i 1 0;
    2 3 0.00493 0.02511i 1 0;
    3 4 0.0366 0.01864i 1 0;
    4 5 0.03811 0.01941i 1 0;
    5 6 0.0819 0.0707i 1 0;
    6 7 0.01872 0.06188i 1 0;
    7 8 0.07114 0.02351i 1 0;
    8 9 0.103 0.074i 1 0;
    9 10 0.1044 0.074i 1 0;
    10 11 0.01966 0.0065i 1 0;
    11 12 0.03744 0.01238i 1 0;
    12 13 0.1468 0.1155i 1 0;
    13 14 0.05416 0.07129i 1 0;
    14 15 0.05910 0.0526i 1 0;
    15 16 0.07463 0.05450i 1 0;
    16 17 0.1289 0.1721i 1 0;
    17 18 0.0732 0.0574i 1 0;
    2 19 0.0164 0.01565i 1 0;
    19 20 0.15042 0.13554i 1 0;
    20 21 0.04095 0.04784i 1 0;
    21 22 0.07089 0.09373i 1 0;
    3 23 0.04512 0.03083i 1 0;
    23 24 0.08980 0.07091i 1 0;
    24 25 0.08960 0.07011i 1 0;
    6 26 0.0203 0.01034i 1 0;
    26 27 0.02842 0.01447i 1 0;
    27 28 0.1059 0.09337i 1 0;
    28 29 0.08042 0.07006i 1 0;
    29 30 0.05075 0.02585i 1 0;
    30 31 0.09744 0.0963i 1 0;
    31 32 0.03105 0.03619i 1 0;
    32 33 0.03410 0.05302i 1 0];
B2=[1 0 0 0 1.05 0;
    2 1 -0.01 -0.006 1 0;
    3 1 -0.009 -0.004 1 0;
    4 1 -0.012 -0.008 1 0;
    5 1 -0.006 -0.003 1 0;
    6 1 -0.006 -0.002 1 0;
    7 1 -0.02 -0.01 1 0;
    8 1 -0.02 -0.01 1 0;
    9 1 -0.006 -0.002 1 0;
    10 1 -0.006 -0.0035 1 0;
    11 1 -0.0045 -0.003 1 0;
    12 1 -0.006 -0.0035 1 0;
    13 1 -0.006 -0.0035 1 0;
    14 1 -0.012 -0.008 1 0;
    15 1 -0.006 -0.001 1 0;
    16 1 -0.006 -0.002 1 0;
    17 1 -0.006 -0.002 1 0;
    18 1 -0.009 -0.004 1 0;
    19 1 -0.009 -0.004 1 0;
    20 1 -0.009 -0.004 1 0;
    21 1 -0.009 -0.004 1 0;
    22 1 -0.009 -0.004 1 0;
    23 1 -0.009 -0.005 1 0;
    24 1 -0.042 -0.02 1 0;
    25 1 -0.042 -0.02 1 0;
    26 1 -0.006 -0.0025 1 0;
    27 1 -0.006 -0.0025 1 0;
    28 1 -0.006 -0.002 1 0;
    29 1 -0.012 -0.007 1 0;
    30 1 -0.02 -0.06 1 0;
    31 1 -0.015 -0.007 1 0;
    32 1 -0.021 -0.01 1 0;
    33 1 -0.006 -0.004 1 0];
node_position=[19,20,21,22];
for i=1:4
B2(node_position(i),3)=B2(node_position(i),3)+load4/10000;  %电动汽车接入
B2(node_position(i),4)=B2(node_position(i),4)+0.484*load4/10000;  %功率因素为0.9
end


Y=zeros(n);               %zeros就是生成一个全0的矩阵
Times=1;                  %置迭代次数为初始值
% for i=1:33
%     B2(i,3)=T_p*B2(i,3);  %负荷随时间变化
%     B2(i,4)=T_p*B2(i,4);
% end
global position
global PV_flage
B2(position(1),3)=B2(position(1),3)+car_1/10000;  %电动汽车接入
B2(position(1),4)=B2(position(1),4)+0.484*car_1/10000;  %功率因素为0.9
B2(position(2),3)=B2(position(2),3)+car_2/10000;  %电动汽车接入
B2(position(2),4)=B2(position(2),4)+0.484*car_2/10000;  %功率因素为0.9
B2(position(3),3)=B2(position(3),3)+car_3/10000;  %电动汽车接入
B2(position(3),4)=B2(position(3),4)+0.484*car_3/10000;  %功率因素为0.9
B2(position(4),3)=B2(position(4),3)-PV_flage*PV/10000;  %光伏接入
B2(position(4),4)=B2(position(4),4)-PV_flage*0.484*PV/10000;  %功率因素为0.9
for i=1:n1
        p=B1(i,1);
        q=B1(i,2);
        Y(p,q)=Y(p,q)-1/((B1(i,3)+B1(i,4))*B1(i,5));
        Y(q,p)=Y(p,q);
        Y(p,p)=Y(p,p)+1/(B1(i,3)+B1(i,4))+0.5*B1(i,6);%
        Y(q,q)=Y(q,q)+1/((B1(i,3)+B1(i,4))*B1(i,5)^2)+0.5*B1(i,6);%高压侧阻抗乘以变比平方  输入时注意低压侧在前
end
%disp('节点导纳矩阵：') ;
Y;
G=real(Y);
B=imag(Y);
OrgS=zeros(2*n-2,1);
DetaS=zeros(2*n-2,1);   %将OrgS、DetaS初始化
%创建OrgS，用于存储初始功率参数
Q=0;
PQV=0;
x=1.655;         %%%x1=6.7,x2=9.85,x=x1+x2；其中x1为定子漏抗，x2为转子漏抗
xp=18.8;         %%%xc=,xm=,xp=xc*xm/(xc-xm)；其中xc为机端并联电容器电抗，xm为激磁电抗
h=0;

for i=1:n    %对PQ(V)节点的处理
    h=h+1;
    if i~=isb&&B2(i,2)==3   
         Q(i)=-(B2(i,5))^2/xp+(-(B2(i,5))^2+sqrt((B2(i,5))^4-4*(B2(i,3))^2*x^2))/2*x;
         B2(i,4)=Q(i);
         B2(i,2)=1; 
         PQV=h;
    end  
end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ig=0.01;
Q=0;
PI=0;
h=0;
for i=1:n    %对PI节点的处理
    h=h+1;
    if i~=isb&&B2(i,2)==4   
         Q(i)=sqrt(Ig^2*((B2(i,5))^2)-B(i,3)^2);        %e=B2(i,5)，f=0，e^2+f^2=B2(i,5))^2，其中e和f为光伏发电系统接入节点电压的实部和虚部
         B2(i,4)=Q(i);
         B2(i,2)=1; 
         PI=h;
    end  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=0;
j=0;
for i=1:n            %对PQ节点的处理
    if i~=isb&&B2(i,2)==1   
        h=h+1;
        for j=1:n
            OrgS(2*h-1,1)=OrgS(2*h-1,1)+B2(i,5)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))+B2(i,6)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));   %Pi 书P57页11-45
            OrgS(2*h,1)=OrgS(2*h,1)+B2(i,6)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))-B2(i,5)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));       %Qi  同上
        end
    end
end
for i=1:n           %对PV节点的处理
    if i~=isb&&B2(i,2)==2
        h=h+1;
        for j=1:n
            OrgS(2*h-1,1)=OrgS(2*h-1,1)+ B2(i,5)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))+B2(i,6)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5)); %同上
            OrgS(2*h,1)=OrgS(2*h,1)+ B2(i,6)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))-B2(i,5)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));    %同上
        end
    end
end
OrgS;
%创建PVU 用于存储PV节点的初始电压
PVU=zeros(n-H-1,2);
t=0;
for i=1:n
    if B2(i,2)==2
        t=t+1;
        PVU(t,1)=B2(i,5);
        PVU(t,2)=B2(i,6);
    end
end
%disp('PV节点初始值:电压、相位ei、fi：')   ; 
PVU;
%创建DetaS，用于存储有功功率、无功功率和电压幅值的不平衡量 书p58 11-46和11-47
h=0;
for i=1:n           %对PQ节点的处理
    if i~=isb&&B2(i,2)==1
        h=h+1;
        DetaS(2*h-1,1)=B2(i,3)-OrgS(2*h-1,1);
        DetaS(2*h,1)=B2(i,4)-OrgS(2*h,1);
    end
end
t=0;
for i=1:n           %对PV节点的处理
    if i~=isb&&B2(i,2)==2
        h=h+1;
        t=t+1;
        DetaS(2*h-1,1)=B2(i,3)-OrgS(2*h-1,1);
        DetaS(2*h,1)=PVU(t,1)^2+PVU(t,2)^2-B2(i,5)^2-B2(i,6)^2;
    end
end
%disp('P、Q、V不平衡量：')  ;
DetaS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%创建I，用于存储节点电流参数（计算雅克比矩阵用 具体见纸板公式推导）
I=zeros(n-1,1);
h=0;
for i=1:n
   if i~=isb
        h=h+1;
        I(h,1)=(OrgS(2*h-1,1)-OrgS(2*h,1)*sqrt(-1))/conj(B2(i,5)+B2(i,6)*sqrt(-1));                                           
    end                                                           
end
I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%创建Jacbi(雅可比矩阵)     各元素是书中各元素求法乘个-1 所以△W=J△V
Jacbi=zeros(2*n-2);
h=0;
k=0;
for i=1:n       %对PQ节点的处理
    if B2(i,2)==1
        h=h+1;
        for j=1:n
            if j~=isb
                k=k+1;
                if i==j     %对角元素的处理
                    Jacbi(2*h-1,2*k-1)=-B(i,j)*B2(i,5)+G(i,j)*B2(i,6)+imag(I(h,1));      
                    Jacbi(2*h-1,2*k)=G(i,j)*B2(i,5)+B(i,j)*B2(i,6)+real(I(h,1));
                    Jacbi(2*h,2*k-1)=-Jacbi(2*h-1,2*k)+2*real(I(h,1));
                    Jacbi(2*h,2*k)=Jacbi(2*h-1,2*k-1)-2*imag(I(h,1));
                else        %非对角元素的处理
                    Jacbi(2*h-1,2*k-1)=-B(i,j)*B2(i,5)+G(i,j)*B2(i,6);
                    Jacbi(2*h-1,2*k)=G(i,j)*B2(i,5)+B(i,j)*B2(i,6);
                    Jacbi(2*h,2*k-1)=-Jacbi(2*h-1,2*k);
                    Jacbi(2*h,2*k)=Jacbi(2*h-1,2*k-1);
                end
                if k==(n-1) %将用于内循环的指针置于初始值，以确保雅可比矩阵换行
                    k=0;
                end
            end
        end
    end
end
k=0;
for i=1:n       %对PV节点的处理
    if B2(i,2)==2
        h=h+1;
        for j=1:n
            if j~=isb
                k=k+1;
                if i==j     %对角元素的处理
                    Jacbi(2*h-1,2*k-1)= -B(i,j)*B2(i,5)+G(i,j)*B2(i,6)+imag(I(h,1));
                    Jacbi(2*h-1,2*k)= G(i,j)*B2(i,5)+B(i,j)*B2(i,6)+real(I(h,1));
                    Jacbi(2*h,2*k-1)=2*B2(i,6);
                    Jacbi(2*h,2*k)=2*B2(i,5);
                else        %非对角元素的处理
                    Jacbi(2*h-1,2*k-1)= -B(i,j)*B2(i,5)+G(i,j)*B2(i,6);
                    Jacbi(2*h-1,2*k)= G(i,j)*B2(i,5)+B(i,j)*B2(i,6);
                    Jacbi(2*h,2*k-1)=0;
                    Jacbi(2*h,2*k)=0;
                end
                if k==(n-1)     %将用于内循环的指针置于初始值，以确保雅可比矩阵换行
                    k=0;
                end
            end
        end
    end
end
%disp('雅克比矩阵为：')  ;
Jacbi; %列参数跟书上的相反   这里面第一列是对电压相位的偏导 第二列是对幅值的偏导
%求解修正方程，获取节点电压的不平衡量
DetaU=zeros(2*n-2,1);
DetaU=Jacbi\DetaS;       
%disp('求解修正方程得：')  ;
DetaU;
%修正节点电压
j=0;
for i=1:n       %对PQ节点处理
    if B2(i,2)==1
        j=j+1;
        B2(i,5)=B2(i,5)+DetaU(2*j,1);
        B2(i,6)=B2(i,6)+DetaU(2*j-1,1);
    end
end
for i=1:n       %对PV节点的处理
    if B2(i,2)==2
        j=j+1;
       B2(i,5)=B2(i,5)+DetaU(2*j,1);
       B2(i,6)=B2(i,6)+DetaU(2*j-1,1);
    end
end
for i=1:n            %对PQ(V)节点的处理
    if i==PQV
       B2(i,2)=3; 
    end
end
for i=1:n            %对PI节点的处理
    if i==PI
       B2(i,2)=4; 
    end
end
%disp('修正后的B2阵：')  ;
B2;
%开始循环**********************************************************************
while max(abs(DetaU))>pr%先取绝对值在找出最大值来与误差精度比较
for i=1:n            %对PQ(V)节点的处理
    if i~=isb&&B2(i,2)==3   
         Q(i)=-(B2(i,5))^2/xp+(-(B2(i,5))^2+sqrt((B2(i,5))^4-4*(B2(i,3))^2*x^2))/2*x;
         B2(i,4)=Q(i);
    end
    if B2(i,2)==3
       B2(i,2)=1; 
    end
end
for i=1:n    %对PI节点的处理
    if i~=isb&&B2(i,2)==4   
         Q(i)=sqrt(Ig^2*((B2(i,5))^2)-B(i,3)^2);       
          B2(i,4)=Q(i);
    end
    if B2(i,2)==4
       B2(i,2)=1; 
    end
end
OrgS=zeros(2*n-2,1);        
h=0;
j=0;
for i=1:n            %对PQ节点的处理
    if i~=isb&&B2(i,2)==1   
        h=h+1;
        for j=1:n
            OrgS(2*h-1,1)=OrgS(2*h-1,1)+B2(i,5)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))+B2(i,6)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));         %Pi
            OrgS(2*h,1)=OrgS(2*h,1)+B2(i,6)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))-B2(i,5)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));            %Qi
        end
    end
end
for i=1:n           %对PV节点的处理
    if i~=isb&&B2(i,2)==2
        h=h+1;
        for j=1:n
            OrgS(2*h-1,1)=OrgS(2*h-1,1)+ B2(i,5)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))+B2(i,6)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));
            OrgS(2*h,1)=OrgS(2*h,1)+ B2(i,6)*(G(i,j)*B2(j,5)-B(i,j)*B2(j,6))-B2(i,5)*(G(i,j)*B2(j,6)+B(i,j)*B2(j,5));
        end
    end
end
%disp('修正后的迭代计算PQ、PV节点参数：') ; 
OrgS;
%创建DetaS
h=0;
for i=1:n           %对PQ节点的处理
    if i~=isb&&B2(i,2)==1
        h=h+1;
        DetaS(2*h-1,1)=B2(i,3)-OrgS(2*h-1,1);
        DetaS(2*h,1)=B2(i,4)-OrgS(2*h,1);
    end
end
t=0;
for i=1:n           %对PV节点的处理
    if i~=isb&&B2(i,2)==2
        h=h+1;
        t=t+1;
        DetaS(2*h-1,1)=B2(i,3)-OrgS(2*h-1,1);
        DetaS(2*h,1)=PVU(t,1)^2+PVU(t,2)^2-B2(i,5)^2-B2(i,6)^2;
    end
end
%disp('修正后的迭代计算PQ、PV节点不平衡量：') ; 
DetaS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%创建I
I=zeros(n-1,1);
h=0;
for i=1:n
    if i~=isb
        h=h+1;
        I(h,1)=(OrgS(2*h-1,1)-OrgS(2*h,1)*sqrt(-1))/conj(B2(i,5)+B2(i,6)*sqrt(-1));                                              
    end                                                           
end
I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%创建Jacbi
Jacbi=zeros(2*n-2);
h=0;
k=0;
for i=1:n       %对PQ节点的处理
    if B2(i,2)==1
        h=h+1;
        for j=1:n
            if j~=isb
                k=k+1;
                if i==j     %对角元素的处理
                    Jacbi(2*h-1,2*k-1)=-B(i,j)*B2(i,5)+G(i,j)*B2(i,6)+imag(I(h,1));           
                    Jacbi(2*h-1,2*k)=G(i,j)*B2(i,5)+B(i,j)*B2(i,6)+real(I(h,1));
                    Jacbi(2*h,2*k-1)=-Jacbi(2*h-1,2*k)+2*real(I(h,1));
                    Jacbi(2*h,2*k)=Jacbi(2*h-1,2*k-1)-2*imag(I(h,1));
                else        %非对角元素的处理
                    Jacbi(2*h-1,2*k-1)=-B(i,j)*B2(i,5)+G(i,j)*B2(i,6);
                    Jacbi(2*h-1,2*k)=G(i,j)*B2(i,5)+B(i,j)*B2(i,6);
                    Jacbi(2*h,2*k-1)=-Jacbi(2*h-1,2*k);
                    Jacbi(2*h,2*k)=Jacbi(2*h-1,2*k-1);
                end
                if k==(n-1) %将用于内循环的指针置于初始值，以确保雅可比矩阵换行
                    k=0;
                end
            end
        end
    end
end
k=0;
for i=1:n       %对PV节点的处理
    if B2(i,2)==2
        h=h+1;
        for j=1:n
            if j~=isb
                k=k+1;
                if i==j     %对角元素的处理
                    Jacbi(2*h-1,2*k-1)= -B(i,j)*B2(i,5)+G(i,j)*B2(i,6)+imag(I(h,1));
                    Jacbi(2*h-1,2*k)= G(i,j)*B2(i,5)+B(i,j)*B2(i,6)+real(I(h,1));
                    Jacbi(2*h,2*k-1)=2*B2(i,6);
                    Jacbi(2*h,2*k)=2*B2(i,5);
                else        %非对角元素的处理
                    Jacbi(2*h-1,2*k-1)= -B(i,j)*B2(i,5)+G(i,j)*B2(i,6);
                    Jacbi(2*h-1,2*k)= G(i,j)*B2(i,5)+B(i,j)*B2(i,6);
                    Jacbi(2*h,2*k-1)=0;
                    Jacbi(2*h,2*k)=0;
                end
                if k==(n-1)     %将用于内循环的指针置于初始值，以确保雅可比矩阵换行
                    k=0;
                end
            end
        end
    end
end
%disp('修正后的雅克比矩阵：')  ;
Jacbi;
DetaU=zeros(2*n-2,1);
DetaU=Jacbi\DetaS;
DetaU;
%修正节点电压
j=0;
for i=1:n       %对PQ节点处理
    if B2(i,2)==1
        j=j+1;
        B2(i,5)=B2(i,5)+DetaU(2*j,1);
        B2(i,6)=B2(i,6)+DetaU(2*j-1,1);
    end
end
for i=1:n       %对PV节点的处理
    if B2(i,2)==2
        j=j+1;
       B2(i,5)=B2(i,5)+DetaU(2*j,1);
       B2(i,6)=B2(i,6)+DetaU(2*j-1,1);
    end
end
for i=1:n            %对PQ(V)节点的处理
    if i==PQV
       B2(i,2)=3; 
    end
end
for i=1:n            %对PI节点的处理
    if i==PI
       B2(i,2)=4; 
    end
end
Times=Times+1;      %迭代次数加1
end
disp('初始潮流计算结果如下：');
disp('迭代次数：');
Times
disp('节点电压幅值如下（按节点由小到大的顺序）：');
B2(:,5)
%创建Sb，用于存储平衡节点功率
Sb=zeros(1);
for i=1:n
    if i==isb
        for j=1:n
     Sb=Sb+(B2(i,5)+sqrt(-1)*B2(i,6))*conj(Y(i,j))*conj(B2(j,5)+sqrt(-1)*B2(j,6)); 
        end                                                           
     end
end
disp('初始平衡节点功率：')
Sb
%求解各条支路的功率
Sij=zeros(n);
for i=1:n
     for j=1:n
     Sij(i,j)=Sij(i,j)+(B2(i,5)+sqrt(-1)*B2(i,6))^2*conj(B1(1,4))+(B2(i,5)+sqrt(-1)*B2(i,6))*conj(Y(i,j))*(conj((B2(i,5)+sqrt(-1)*B2(i,6)))-conj((B2(j,5)+sqrt(-1)*B2(j,6)))); 
      end
end
%disp('线路功率分布：')
Sij;
Sij_P=real(Sij);
Sij_Q=imag(Sij);
for i=1:32
     P_flow(i)=  abs( Sij_P(B1(i,1),B1(i,2)));
end

for i=1:33
    for j=1:33
        if Sij_P(i,j)<0.0001
             Sij_P(i,j)=0;
        end
         if Sij_Q(i,j)<0.0001
             Sij_Q(i,j)=0;
         end
    end
end
%%%求解系统网损
Ploss=0;
for i=1:n            
        for j=1:n
            Ploss=Ploss+B2(i,5)*B2(j,5)*(G(i,j)*cos(B2(i,6)-B2(j,6))+B(i,j)*sin(B2(i,6)-B2(j,6))); 
        end
end
Ploss=Ploss*10000;
 V_amp=B2(:,5);
for i=1:n  %电压罚函数
    V_33(i)=abs(1-V_amp(i)); %求与额定电压的差值
end
V_flu=sum(V_33);

end


 
