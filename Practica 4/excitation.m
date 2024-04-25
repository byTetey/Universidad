function [exc new_exc_shift]=excitation(voiced, pitch_period, exc_shift,desp)    

  if (voiced)
     exc=zeros(1,desp);
     j=exc_shift:pitch_period:length(exc);
     exc(j)=1; 
     exc_shift=pitch_period-(length(exc)-j(end));
  else
      exc=randn(1,desp);
      exc_shift=1;
  end;    
  
  new_exc_shift=exc_shift;
  