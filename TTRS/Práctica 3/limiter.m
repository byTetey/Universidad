function x=limiter(x,amp)

ind=find(x>amp);
x(ind)=amp;
ind=find(x<-amp);
x(ind)=-amp;

end