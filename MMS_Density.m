function [centers,allMembers] = MMS_Density(inputData,h)

y_new = [];
centers = [];
inputData1=inputData;
inputData=inputData(:,2:end);
[n d]=size(inputData);
numPts = size(inputData,1);
dataSpace = inputData;
ic = 1;
ij=0;
start = 0;

for ik=1:n
    
    %inititaion
    start = ik;
    y_j = dataSpace(start,:);
    cMembers = [];
    L2Dist = sqrt(sum((repmat(y_j,size(inputData,1),1)- inputData).^2,2));
    HH=sqrt(sum(h.^2,2));
    inPts = find(prod(L2Dist< HH,2));
    X = inputData(inPts,:);
    XX = inputData1(inPts,:);
    cMembers = [cMembers XX'];
    
    if ic == 1
        mergers = 0;
    else
        clustDist = sqrt(sum((y_new(ones(size(centers,1),1),:)-centers).^2,2));
        mergers = find(clustDist < h/2);
    end
    adad=[];
    if mergers
        for imr = 1:size(mergers,1)
            imerg=mergers(imr,1);
            adad=adad+1;
            allMembers{imerg} = unique([allMembers{imerg};cMembers'],'rows');
        end
    else
        allMembers{ic} = cMembers';
        ic = ic + 1;
    end
    
end

