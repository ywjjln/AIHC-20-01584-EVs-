function T_start=get_start()
%get_star 得到起始充电时间
while 1
    T=round(normrnd(17.6,3.4));
    if T<=0||T>24
        continue;
    end
    break;

end

T_start=T;