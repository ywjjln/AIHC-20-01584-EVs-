function mileage=get_mileage()
%get_qua �õ������
while 1
    [mu,sigma]=lognstat(3.22,0.88);   %��������̬�ֲ���mu��sigma��
    P=normrnd(mu,sigma);
    if P<0
        continue;
    end
    break;
end
mileage=P;
