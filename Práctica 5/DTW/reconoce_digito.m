
addpath('./voicebox');

calcula_cepstrum=1;
fs = 16000;
beep=audioread('beep.wav');
sound(beep,fs);

recObj = audiorecorder(fs,16,2);
disp('Start speaking.')
recordblocking(recObj, 1);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
y = getaudiodata(recObj);

y = audioread('audio/digitos/siete01.wav');     % LE PASAMOS UN ARCHIVO EN EL QUE SE DICE UN DIGITO

Y= melcepst(y,fs)';   

if(calcula_cepstrum)

    [d0,fs] = audioread('audio/digitos/cero01.wav');
    [d1,fs] = audioread('audio/digitos/uno01.wav');
    [d2,fs] = audioread('audio/digitos/dos01.wav');
    [d3,fs] = audioread('audio/digitos/tres01.wav');
    [d4,fs] = audioread('audio/digitos/cuatro01.wav');
    [d5,fs] = audioread('audio/digitos/cinco01.wav');
    [d6,fs] = audioread('audio/digitos/seis01.wav');
    [d7,fs] = audioread('audio/digitos/siete01.wav');
    [d8,fs] = audioread('audio/digitos/ocho01.wav');
    [d9,fs] = audioread('audio/digitos/nueve01.wav');

    D0 = melcepst(d0,fs)';      % CALCULA EL MEL-CEPSTRUM DE CADA UNO DE LOS Nº
    D1 = melcepst(d1,fs)'; 
    D2 = melcepst(d2,fs)';   
    D3 = melcepst(d3,fs)'; 
    D4 = melcepst(d4,fs)';   
    D5 = melcepst(d5,fs)'; 
    D6 = melcepst(d6,fs)';   
    D7 = melcepst(d7,fs)'; 
    D8 = melcepst(d8,fs)';   
    D9 = melcepst(d9,fs)'; 

    save melpcestrum_digitos D0 D1 D2 D3 D4 D5 D6 D7 D8 D9;

else
    load melpcestrum_digitos;
end
 
SM0 = simmx(D0,Y); [p0,q0,C0] = dp2(1-SM0); % SE CALCULA EL PARECIDO MEDIANTE DTW 
SM1 = simmx(D1,Y); [p1,q1,C1] = dp2(1-SM1);
SM2 = simmx(D2,Y); [p2,q2,C2] = dp2(1-SM2);
SM3 = simmx(D3,Y); [p3,q3,C3] = dp2(1-SM3);
SM4 = simmx(D4,Y); [p4,q4,C4] = dp2(1-SM4);
SM5 = simmx(D5,Y); [p5,q5,C5] = dp2(1-SM5);
SM6 = simmx(D6,Y); [p6,q6,C6] = dp2(1-SM6);
SM7 = simmx(D7,Y); [p7,q7,C7] = dp2(1-SM7);
SM8 = simmx(D8,Y); [p8,q8,C8] = dp2(1-SM8);
SM9 = simmx(D9,Y); [p9,q9,C9] = dp2(1-SM9);

COST=[0:9; 
           C0(size(C0,1),size(C0,2)) C1(size(C1,1),size(C1,2)) ...
           C2(size(C2,1),size(C2,2)) C3(size(C3,1),size(C3,2)) ...
           C4(size(C4,1),size(C4,2)) C5(size(C5,1),size(C5,2)) ...
           C6(size(C6,1),size(C6,2)) C7(size(C7,1),size(C7,2)) ...
           C8(size(C8,1),size(C8,2)) C9(size(C9,1),size(C9,2))]';
     
COST=sortrows(COST,2)

 switch COST(1,1)
          case 0
            SM=SM0; p=p0; q=q0;
          case 1
            SM=SM1; p=p1; q=q1;
          case 2
            SM=SM2; p=p2; q=q2;
          case 3
            SM=SM3; p=p3; q=q3;
          case 4
            SM=SM4; p=p4; q=q4;
          case 5
            SM=SM5; p=p5; q=q5;
          case 6
            SM=SM6; p=p6; q=q6;
          case 7
            SM=SM7; p=p7; q=q7;
          case 8
            SM=SM8; p=p8; q=q8;
          case 9
            SM=SM9; p=p9; q=q9;      
 end
 
 figure(1);

 imagesc(SM);
 colormap(flipud(gray));
 hold on; plot(q,p,'r'); hold off


