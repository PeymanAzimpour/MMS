function trainall = gt_design(data)
class = data ;
[M N]=size(class);
Gt=reshape(class,M*N,1);
n_gt=1:M*N;
Gt=double(Gt);
GT=[n_gt' Gt];
% GT(1000,:)
idx=(Gt~=0);
y=1:max(Gt(:));
train = GT(idx,:);
 k=0;
for j=1:size(y,2)
    yy=y(1,j);
   
    for i=1:size(train,1)
        if train(i,2)==yy
            k=k+1;
            trainall(k,:)=train(i,:);
        end
    end
end

        