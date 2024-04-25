function sint=codecsin(fichero)

nfft=1024;
long=80;
solape=80;
leidos=long+solape;

ampold=zeros(1,nfft/2+1);
phold=zeros(1,nfft/2+1);

t=1;
n=1:nfft/2+1;
sint=[];
primera=1;

while(leidos==long+solape)
%while (t<168)
	

	[trama leidos]=leetrama(fichero,t,long,solape,'h');        

	[frec,amp,ph]=picos(trama,nfft);
	

	%representa(trama,frec,amp);
	             
	
	if(primera==1) frecold=frec;
		          primera=0;
	end;

%  	ph=ph(2:length(ph));
%	ph=[ph 0];
	
	sint=[sint oscila2(frec,amp,ph,frecold,ampold,phold,long)];

	ampold=amp;
	phold=ph;
	frecold=frec;
	t=t+1

end;	

