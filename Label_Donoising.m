function [member,unmember] = Label_Donoising(inputData,h,Xm)

inputData=inputData(:,2:end);
[n d]=size(inputData);
member=[];

H=sqrt(sum(h.^2,2));
LXm =  sqrt(sum((Xm(ones(size(inputData,1),1),:) - inputData).^2,2));
L = (exp((-LXm)));
L1=H+ H.*(exp(-H^2)) ;
inPts = find(prod(LXm.*(1-L)< L1,2));
P_data=[1:size(inputData,1)]';
uninPts = P_data;
uninPts(inPts,:)=[];
member=inPts;
unmember=uninPts;

end