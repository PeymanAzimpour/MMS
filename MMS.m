function   [x1,y1,chosenData] = MMS(Xtrain,Ytrain,num,class)

Ytrain = Ytrain';
Xtrain = Xtrain';
k=0;
for j=1:class
    yy=j;
    
    for i=1:size(Ytrain,1)
        if Ytrain(i,2)==yy
            k=k+1;
            train(k,:)=Ytrain(i,:);
        end
    end
end

denoi_x=[];
denoi_y=[];
h=1;
chosenData=[];
Params=[];
unMember_Data=[];

for i=1:class
    cluster=i;
    id=(train(:,2)==i);
    ind = train(id,:);
    inddd=ind(1:num(1,i),1);
    data = [ind(:,1) Xtrain(ind(:,1),:)];
    data1=data(:,2:end);
    [n d]=size(data1);
    
    H=std(data1)*(4/((d+2)*n))^(1/(d+4));
    
    [centers,allMembers] = MMS_Density(data,H);
    
    
    sz=[];
    for j=1:size(allMembers,2)
        sz(1,j)=[size(allMembers{j},1)];
    end
    K=[];
    for ik=1:size(sz,2)
        train1 = allMembers{ik};
        K(ik,1)=size(train1,1);
    end
    %%
    K_data=K./sum(K);
    data2=K_data.*data1;
    Xm=sum(data2);
    H=std(data2)*(4/((d+2)*n))^(1/(d+4));
    st=sqrt(sum(K.*((data1-Xm).^2))/(sum(K)-1));
    Hm=st *(4/((d+2)*n))^(1/(d+4));
    [member,unmember] = Label_Donoising(data,Hm,Xm);
    
    Params(:,:,i)=[H;Xm];
    
    Ch_Data=data(member,:);
    unMember_Data=[unMember_Data;data(unmember,:)];
    
    train1 =Ch_Data;
    denoi_x=[denoi_x;train1];
    
    %%
    aa=train1(:,1);
    a=0;
    for ii=1:size(inddd,1)
        a=a+sum(inddd(ii,1)==aa);
    end
    b=size(train1,1)-a;
    chosenData(i,1)=a;
    chosenData(i,2)=b;
    chosenData(i,3)=num(1,i);
    chosenData(i,4)=size(data,1)-num(1,i);
    chosenData(i,5)=(chosenData(i,2)/chosenData(i,1))*100;
    chosenData(i,6)=(chosenData(i,4)/chosenData(i,3))*100;
end

for iii=1:size(denoi_x,1)
    idis=repmat(denoi_x(iii,1),size(Ytrain,1),1);
    idd=(Ytrain(:,1)==idis);
    denoi_y=[denoi_y;Ytrain(idd,2)];
end
y1=denoi_y';
x1=denoi_x';

