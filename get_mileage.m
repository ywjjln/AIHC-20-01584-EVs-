function mileage=get_mileage()
%get_qua 得到充电量
while 1
    [mu,sigma]=lognstat(3.22,0.88);   %求解对数正态分布的mu和sigma。
    P=normrnd(mu,sigma);
    if P<0
        continue;
    end
    break;
end
mileage=P;
