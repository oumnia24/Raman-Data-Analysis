load OnePicoLib.mat
whos M Names

% load 'DTTC 0.23pM+IR780+IR775+IR797+IR813_no_bck.txt'
whos new_variable
% whos B
% M = DTTC_0_23pM_IR780_IR775_IR797_IR813_no_bck
both_mixtures = [mixture1.Y mixture2.Y]

% transposed_m = M.'
transposed_m = new_variable.Y.'
% transposed_m = B.'
% transposed_names = reshape(1:182, 182, 1);
transposed_names = new_variable.Z.'
% transposed_names = reshape(1:5, 5, 1);




[dummy,h] = sort(transposed_names);
oldorder = get(gcf,'DefaultAxesColorOrder');
% set(gcf,'DefaultAxesColorOrder',jet(182));
set(gcf,'DefaultAxesColorOrder',jet(210));
% set(gcf,'DefaultAxesColorOrder',jet(5));
% plot3(repmat(1:1011,182,1)',repmat(transposed_names(h),1,1011)',transposed_m(h,:)');
figure(1)
plot3(repmat(1:1011,210,1)',repmat(transposed_names(h),1,1011)',transposed_m(h,:)');
% plot3(repmat(1:1011,5,1)',repmat(transposed_names(h),1,1011)',transposed_m(h,:)');
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

[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,5);
yfitPLS = [ones(n,1) X]*betaPLS;

[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
betaPCR = regress(y-mean(y), PCAScores(:,1:5));

betaPCR = PCALoadings(:,1:5)*betaPCR;
betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) X]*betaPCR;

plot(y,yfitPLS,'bo',y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 5 Components' 'PCR with 5 Components'},  ...
	'location','NW');

TSS = sum((y-mean(y)).^2);
RSS_PLS = sum((y-yfitPLS).^2);
rsquaredPLS = 1 - RSS_PLS/TSS
% 
% RSS_PCR = sum((y-yfitPCR).^2);
% rsquaredPCR = 1 - RSS_PCR/TSS
% 
% plot(1:4,100*cumsum(PLSPctVar(1,:)),'b-o',1:4,  ...
% 	100*cumsum(PCAVar(1:4))/sum(PCAVar(1:4)),'r-^');
% xlabel('Number of Principal Components');
% ylabel('Percent Variance Explained in X');
% legend({'PLSR' 'PCR'},'location','SE');
