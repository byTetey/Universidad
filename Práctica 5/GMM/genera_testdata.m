mu1 = [1 1]; SIGMA1 = [1 0; 0 1];
mu2=[1 3];  SIGMA2 = [0.5 0; 0 0.9];
mu3=[-1 3];  SIGMA3 = [1.5 0; 0 0.9];
mu4=[3 1];  SIGMA4 = [1.5 0; 0 0.9];
mu5 = [-1 -1]; SIGMA5 = [0.5 0; 0 0.7];
mu6 = [6 6]; SIGMA6 = [0.5 0; 0 0.5];
mu7 = [7 -2]; SIGMA7 = [0.5 0; 0 0.5];

R=[];
for i=1:200
    r1 = mvnrnd(mu1,SIGMA1,10); % genera vectores de dimension 2 que son gaussianas
    r2 = mvnrnd(mu2,SIGMA2,10);
    r3 = mvnrnd(mu3,SIGMA3,10);
    r4 = mvnrnd(mu4,SIGMA4,10);
    r5 = mvnrnd(mu5,SIGMA5,10);
    r6 = mvnrnd(mu6,SIGMA6,10);
    r7 = mvnrnd(mu7,SIGMA7,10);
    
    R=[R; r1; r2; r3; r4 ; r5; r6; r7];
end

plot(R(:,1),R(:,2),'.')
testdata=R;
save testdata.mat testdata
