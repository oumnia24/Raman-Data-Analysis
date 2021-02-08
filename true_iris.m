% load ionosphere
% tbl = array2table(X);
% tbl.Y = Y;
% % import y;
% % load X;
% 
% rng('default') % For reproducibility
% n = length(tbl.Y);
% hpartition = cvpartition(n,'Holdout',0.3); % Nonstratified partition
% idxTrain = training(hpartition);
% tblTrain = tbl(idxTrain,:);
% idxNew = test(hpartition);
% tblNew = tbl(idxNew,:);
% 
% Mdl = fitcsvm(tblTrain,'Y');
% trainError = resubLoss(Mdl)
% trainAccuracy = 1-trainError

load fisheriris
% rng('default') % For reproducibility
% c = cvpartition(species,'KFold',5);

species = categorical(species);
C = categories(species)