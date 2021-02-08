load OnePicoLib.mat

mixture1 = tgspcread('Mixture 1.spc');
mixture2 = tgspcread('Mixture 2.spc');
mixture3 = tgspcread('Mixture 3.spc');
mixture4 = tgspcread('Mixture 4.spc');
mixture5 = tgspcread('Mixture 5.spc');


both_mixtures_y = [mixture1.Y mixture2.Y mixture3.Y mixture4.Y mixture5.Y];


transposed_m = both_mixtures_y.';
transposed_names = reshape(1:1023, 1023, 1);


[dummy,h] = sort(transposed_names);
oldorder = get(gcf,'DefaultAxesColorOrder');
set(gcf,'DefaultAxesColorOrder',jet(1023));
figure(1)
plot3(repmat(1:1011,1023,1)',repmat(transposed_names(h),1,1011)',transposed_m(h,:)');
set(gcf,'DefaultAxesColorOrder',oldorder);
xlabel('Raman Shift cm'); ylabel('Nanoparticles'); axis('tight');
grid on

X = transposed_m;
y = transposed_names;
[n,p] = size(X);
[Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(X,y,10);

figure(2)
plot(1:10,cumsum(100*PLSPctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');

[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,3);
yfitPLS = [ones(n,1) X]*betaPLS;


[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
betaPCR = regress(y-mean(y), PCAScores(:,1:3));

betaPCR = PCALoadings(:,1:3)*betaPCR;
betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) X]*betaPCR;

figure(3)
plot(y,yfitPLS,'bo',y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 3 Components' 'PCR with 3 Components'},  ...
	'location','NW');

TSS = sum((y-mean(y)).^2);
RSS_PLS = sum((y-yfitPLS).^2);
rsquaredPLS = 1 - RSS_PLS/TSS

RSS_PCR = sum((y-yfitPCR).^2);
rsquaredPCR = 1 - RSS_PCR/TSS

% Mean squared prediction error for different numbers of components
figure(4)
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X,y,10,'CV',10);
PCRmsep = sum(crossval(@pcrsse,X,y,'KFold',10),1) / n;
plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^');
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR' 'PCR'},'location','NE');

% plot(1:4,100*cumsum(PLSPctVar(1,:)),'b-o',1:4,  ...
% 	100*cumsum(PCAVar(1:4))/sum(PCAVar(1:4)),'r-^');
% xlabel('Number of Principal Components');
% ylabel('Percent Variance Explained in X');
% legend({'PLSR' 'PCR'},'location','SE');
