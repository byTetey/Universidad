
load testdata.mat

X=testdata;

GMModel = fitgmdist(X,5);
%Plot the data over the fitted Gaussian mixture model contours.

figure(1);

scatter(X(:,1),X(:,2),5,'MarkerFaceColor',[0 .7 .7]) % Scatter plot with points of size 10
interval=axis;
hold on

ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]),interval)
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
hold off