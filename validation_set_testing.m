%Testing on validation set


mixture6 = tgspcread('Mixture 6.spc')

testing_X = mixture2.Y.'

testing_Y = reshape(1:196, 196,1)

yvalfit = [ones(196 ,1) testing_X]*betaPLS;
TSSVal = sum(((testing_Y)-mean(testing_Y)).^2);
RSSVal = sum((testing_Y-yvalfit).^2);
RsquaredVal = 1 - RSSVal/TSSVal

yvalfitPCR = [ones(196 ,1) testing_X]*betaPCR;
TSSVal = sum(((testing_Y)-mean(testing_Y)).^2);
RSSVal = sum((testing_Y-yvalfitPCR).^2);
RsquaredValPCR = 1 - RSSVal/TSSVal

