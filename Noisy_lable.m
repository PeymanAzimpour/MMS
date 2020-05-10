function [new_train,indexes] = Noisy_lable (trainall,indexes,number,class,Label_noise)

KK=Label_noise;


ind=1:size(trainall,2);
index=[ind' trainall'];
new_train=[];
for i=1:class
    Data = index;
Data(indexes,:) = [];
    idx=(Data(:,3)~=i);
    data = Data(idx,:);
    N_noisy=ceil(number(1,i)*KK);

    LL=randperm(size(data,1));
   
    for j=1:N_noisy
        data(LL(j),3)=i;
        new_train=[new_train;data(LL(j),:)];
        indexes=[indexes;data(LL(j),1)];
    end
   
end
