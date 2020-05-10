clc
clear all
load Salinas;
im = salinas;
sz = size(im);
clear img;


Label_noise=0.5;
[M,N,B] = size(im);
for ii=1:B
    band=im(:,:,ii);
    mx(ii)=max(band(:));
    mn(ii)=min(band(:));
    band_normal=((band-mn(ii))/(mx(ii)-mn(ii)));
    im(:,:,ii)=band_normal;
end

im = ToVector(im);
im = im';
im([108:112 154:167 224],:) =[];
sz(3) = size(im,1);

load('Salinas_gt')
data = salinas_gt;
trainall = gt_design(data);
trainall = trainall';

trainData_number=[200 372 197 139 267 395 357 1127 620 327 106 192 91 107 726 180];
class=16;

% Choose_Type = 'Random';
Choose_Type = 'Fixed';

SVM_classification_CA=[];
MMiter=2;

for iter = 1:MMiter
    iter
    
    switch Choose_Type
        case 'Random'
            indexes = train_test_random_new(trainall(2,:),train_perclass,n_train);
        case 'Fixed'
            indexes = train_test_random_newvector(trainall(2,:),trainData_number);
    end
    train = trainall(:,indexes);
    
    [new_train,indexes] = Noisy_lable (trainall,indexes,trainData_number,class,Label_noise);
    train1=[train new_train(:,2:end)'];
    test1 = trainall;
    test1(:,indexes) = [];
    Noisy_gt=trainall;
    Noisy_gt(:,indexes) = train1;
    
    train = im(:,train1(1,:));
    test = im(:,test1(1,:));
    y = train1(2,:);
    x = train;
    
    train11=train1;
    tic;
    [x1,y1,chosenData]=MMS(im,train11,trainData_number,class);
    train1=x1(1,:);
    x=x1(2:end,:);
    y=y1;
    
    
    % SVM Classification
    
    Model = fitcecoc(x',y');
    predict_class=predict(Model,im');
    predict_class=predict_class';
    SVM_time(iter)=toc;
    
    % Find Accuracy
    OA_SVM_AL(iter)     =  sum(predict_class(test1(1,:))==test1(2,:))/length(test1(2,:));
    [a.OA,a.kappa,a.AA,a.CA] = calcError( test1(2,:)-1, predict_class(test1(1,:))-1, 1: class);
    SVM_classification_OA(iter) = a.OA;
    SVM_classification_AA(iter) = a.AA;
    SVM_classification_kappa(iter) = a.kappa;
    SVM_classification_CA = [SVM_classification_CA a.CA];
    
    
end

mean_classification_SVM_OA = mean(SVM_classification_OA.*100);
STD_classification_SVM_OA = std(SVM_classification_OA.*100);
mean_classification_SVM_AA = mean(SVM_classification_AA.*100);
STD_classification_SVM_AA = std(SVM_classification_AA.*100);
mean_classification_SVM_kappa = mean(SVM_classification_kappa);
STD_classification_SVM_kappa = std(SVM_classification_kappa);
mean_classification_SVM_CA = mean(SVM_classification_CA.*100,2);
STD_classification_SVM_CA = std(SVM_classification_CA.*100,0,2);
mean_SVM_time = mean(SVM_time);
STD_SVM_time = std(SVM_time);

fprintf('The OA of SVM classification proposed is %4.2f%%\n',mean(mean_classification_SVM_OA));



