% MATLAB SIMULATION OF ISO/IEC MPEG-1 PSYCHOACOUSTIC MODEL-1
% COPYRIGHT (C) 2003-07  VENKATRAMAN ATTI and ANDREAS SPANIAS
%
% This Copyright applies only to this particular MATLAB implementation
% of the Psychoacoustic model-1.  The MATLAB software is intended only for educational
% purposes.  No other use is intended or authorized.  This is not a public
% domain program and unauthorized distribution to individuals or networks 
% is prohibited. Be aware that use of the standard in any form is goverened
% by rules of the ISO/IEC MPEG Committee.  
% This program is free software. It is distributed in the hope that it will
% be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  There is no commitment 
% or even implied commitment on behalf of Venkatraman Atti or Andreas Spanias
% for maintenance or support of this code.
%
% MATLAB is trademark of The Mathworks Inc
%
% ALL DERIVATIVE WORKS MUST INCLUDE THIS COPYRIGHT NOTICE.
% ******************************************************************
% ISO/IEC 11172-3 (MPEG-1) Psychoacoustic Model-1
% ******************************************************************
function [P, Thr_global]=psychoacoustics(current_frame, N, View_fig)

	global fr_size  fft_size  fr_count 
	global fs  bit_res
	global freq_hz  freq_bark  Abs_thr

  % Define the constants
  fs = 44100;
	fr_size = N;                                      % Number of samples per frame
	fft_size = N;                                     % FFT size
	freq_hz = [1 : fft_size/2+1] * (fs / fft_size);   % Freq. bins in Hz
  freq_bark = 13 * atan(.00076*freq_hz) + 3.5 * atan((freq_hz/7500).^2);  %Eq. (5.3)  % Bark indices corresponding to freq. bins

  %Eq. (5.1)  % Absolute Threshold in quiet            
	Abs_thr = 3.64.*(freq_hz./1000).^(-.8) - 6.5.*exp(-0.6.*(freq_hz./1000-3.3).^2) + 0.001.*(freq_hz./1000).^4;
    
  
	% Step-1: Spectral analysis and SPL Normalization ------------------->>>>>>>
	[P] = psy_step_1( current_frame);       % This function uses Eq. (5.18) - (5.20)
		
	% Step-2: Identification of tonal and noie maskers ------------------->>>>>>>
	[P_TM, P_NM] = psy_step_2( P );         % This function uses Eq.(5.21) - (5.25)
			% Plotting            
			if (View_fig == 1)
        figure(1), plot(freq_bark, P);
        hold on;
        hold on, plot(freq_bark, Abs_thr, 'r:');
        TM_ind=find(P_TM>0);
        NM_ind=find(P_NM>0);
        plot(freq_bark(TM_ind), P_TM(TM_ind), 'x');
        plot(freq_bark(NM_ind), P_NM(NM_ind), 'o');
        hold off,
        set(gca, 'ylim', [-20, 100]);
        legend('PSD', 'Absolute Threshold', 'Tone maskers', 'Noise maskers');
        set(gca,'XminorGrid','on');
        pause, 
			end

	% Step-3: Decimation and re-organization of maskers ------------------->>>>>>>
	[P_TM_th, P_NM_th] = psy_step_3( P_TM, P_NM );   % This function uses Eq.(5.26) - (5.29)
		% Plotting            
		if (View_fig == 1)
      figure(2), plot(freq_bark, P);
      hold on, plot(freq_bark, Abs_thr, ':');
       TM_ind=find(P_TM_th>0);
       NM_ind=find(P_NM_th>0);
        plot(freq_bark(TM_ind), P_TM(TM_ind), 'rx');
        plot(freq_bark(NM_ind), P_NM(NM_ind), 'ko');
	  %plot(freq_bark, P_TM_th, 'rx');
      %plot(freq_bark, P_NM_th, 'ko');            
      set(gca, 'ylim', [-20, 100]);
      legend('PSD', 'Absolute Threshold', 'Selected tone maskers', 'Selected noise maskers');
      set(gca,'XminorGrid','on')
      hold off,
      pause,
		end


	% Step-4: Calculation of individual masking thresholds ------------------->>>>>>>
	[Thr_TM, Thr_NM] = psy_step_4( P_TM_th, P_NM_th );               % This function uses Eq.(5.30) - (5.32)
    % Plotting            
    if (View_fig == 1)
      figure(3), plot(freq_bark, 10*log10(Thr_TM+eps), 'r:');
      hold on, plot(freq_bark, 10*log10(Thr_NM+eps), 'k:');
      legend('Tone masking threshold', 'Noise masking threshold');
      set(gca, 'ylim', [-20, 100]);
      hold off,
      pause,
    end
            
	% Step-5: Calculation of global masking thresholds  ------------------->>>>>>>
	[Thr_global] = psy_step_5( Thr_TM, Thr_NM );                       % This function uses Eq.(5.33)
	Thr_global = 10*log10(Thr_global);
		% Plotting            
		if (View_fig == 1)
      figure(4), plot(freq_bark, (Thr_global), 'k');
      legend('JND curve');    %Also called the global masking threshold
      set(gca, 'ylim', [-20, 100]);
      hold off,
      pause
		end
            
  

%--------------------------------------------------------------------------
% Step-1: Spectral analysis and SPL Normalization
%--------------------------------------------------------------------------

function [ P ] = psy_step_1( s )       % This function uses Eq. (5.18) - (5.20)

    global fr_size fft_size fr_count bit_res
	global freq_hz  freq_bark  Abs_thr
    
    PN = 90.302;    % power normalization term, PN
    
    % Normalize the input audio samples according to the FFT length 
    %  and the number of bits per sample              ------------------->>>>>>> Part - 1(a)
	%         x = s / ( fft_size * (2^(bit_res-1)) );         % Eq. 5.18
	% Since audioread in MATLAB returns amplitude in the range [-1, +1], 
    % Normalization w.r.t. bits/sample is not required here
            x = s / fft_size;         % Eq. 5.18 (moodified with out bit/sample normalization)
        
	%  Design the Hanning window, w(n)              ------------------->>>>>>> Part - 1(b)
            w = ones(fr_size, 1);                      % Eq. 5.20
  
    %  Compute the power spectral density (PSD), P         ------------------->>>>>>> Part - 1(c)
            P = PN + 10*log10( (abs(fft(w.*x, fft_size))).^2 );         % Eq. 5.19
            P = P(1: fft_size/2+1);       % Only first half is required
           
        
%--------------------------------------------------------------------------
% Step-2: Identification of tonal and noie maskers
%--------------------------------------------------------------------------

function [P_TM, P_NM] = psy_step_2( P )                       % This function uses Eq.(5.21) - (5.25)

    global fr_size fft_size fr_count fs bit_res
	global freq_hz  freq_bark

		% Browse through the power spectral density, P 
        % to determine the tone maskers --------------------------------->>>>>>> Part-2(a)
		P_TM = zeros(1, length(P));
		for k = 1 : length(P),
           if(tone_masker_check(P, k))       % if index k corresponds to a tone
              % Combine the energy from three adjacent spectral components 
              % centered at the peak to form a single tonal masker 
                  P_TM(k) = 10*log10(10.^(0.1.*P(k-1))+10.^(0.1.*P(k))+10.^(0.1.*P(k+1)));      %Eq. (5.23)
           end
		end
				
	% Find noise maskers within the critical band-------------------------------->>>>>>> Part-2(b)
		P_NM = zeros(1, length(P_TM));
		lowbin = 1;                                         % lower spectral line boundary of the critical bank, l
		highbin = max(find(freq_bark < 1));     % upper spectral line boundary of the critical bank, u
                                                % loc is the geometric mean spectral line of the critical band, Eq. (5.25)
		% remainder of critical bands can be done with loop
		for band = 1:24,
           [noise_masker_at_loc, loc] = noise_masker_check(P, P_TM, lowbin, highbin);
           if (loc ~= -1)
              P_NM(floor(loc)) = noise_masker_at_loc;
           end
           lowbin = highbin;
           highbin = max(find(freq_bark<(band+1)));
		end
        
                 
%************************************************************************ SUBFUNCTIONS BEGIN---->>>>>>>
	%------------------------------------------------------------------------------->>>>>>> Subfunction-2(a).I
		function bool = tone_masker_check(P, k)
		% If P(k) is a local maxima and is greater than 7dB in
		% a frequency dependent neighborhood, it is a tone.         See section (5.7.2)------->>>
		% This neighborhood is defined as:                                  Eq. (5.22)------>>>
		%   within 2           if 2   < k  < 63, for frequencies between 0.17-5.5kHz
		%   within 2,3            63  <= k < 127, for frequencies between 5.5-11Khz
		%   within 2,3,4,5,6      127 <= k < 256, for frequencies between 11-20Khz
		
		% If it is at the beginning or end of P, then it is not a local maxima      
        % The if... else... statements below computes the tonal set given by Eq. (5.21) ------>>>
		if ((k<=1) | (k>=250))
           bool = 0;
		% if it's not a local maxima, leave with bool=0
		elseif ((P(k)<P(k-1)) | (P(k)<P(k+1))),
           bool = 0;
           % otherwise, we need to check if it is a max in its
           % neighborhood.
		elseif ((k>2) & (k<63)),
           bool = ((P(k)>(P(k-2)+7)) & (P(k)>(P(k+2)+7)));
		elseif ((k>=63) & (k<127)),
           bool = ((P(k)>(P(k-2)+7)) & (P(k)>(P(k+2)+7)) & (P(k)>(P(k-3)+7)) & (P(k)>(P(k+3)+7)));
		elseif ((k>=127) & (k<=256)),
           bool = ((P(k)>(P(k-2)+7)) & (P(k)>(P(k+2)+7)) & (P(k)>(P(k-3)+7)) & (P(k)>(P(k+3)+7)) ...
                     & (P(k)>(P(k-4)+7)) & (P(k)>(P(k+4)+7)) & (P(k)>(P(k-5)+7)) & (P(k)>(P(k+5)+7)) ...
                     & (P(k)>(P(k-6)+7)) & (P(k)>(P(k+6)+7)));
		else
           bool = 0;
		end

	%------------------------------------------------------------------------------->>>>>>> Subfunction-2(b).I
		function [noise_masker_at_loc, loc] = noise_masker_check(psd, tone_masker, low, high)
		
			noise_members = ones(1,high-low+1);
			% Browse through the power spectral density, P 
            % to determine the noise maskers
			for k = low:high,
               % if there is a tone
               if (tone_masker(k) > 0),
                  % check frequency location and determine neighborhood length
                  if ((k>2) & (k<63))
                     m = 2;
                  elseif((k>=63) & (k<127))
                     m = 3;
                  elseif((k>=127) & (k<256))
                     m = 6;
                 else
                     m = 0;
                  end
                  % set all members of the neighborhood to 0 that
                  % removes them from the list of noise members
                  for n = (k-low+1)-m:(k-low+1)+m,
                     if (n > 0)
                        noise_members(n) = 0;
                     end
                  end
               end
			end
			
			% if there are no noise members in the range, then leave
			if (isempty(find(noise_members)))
               noise_masker_at_loc = 0;
               loc = -1;
           else
               temp = 0;
				for k = (low+find(noise_members)-1),
                  temp = temp + 10.^(0.1.*psd(k));
				end
                noise_masker_at_loc = 10*log10(temp);
               loc = geomean(low+find(noise_members)-1);
           end
           
           
%--------------------------------------------------------------------------
% Step-3: Decimation and re-organization of maskers 
%--------------------------------------------------------------------------

function [TM_above_thres, NM_above_thres] = psy_step_3( tone_masker, noise_masker )         % This function uses Eq.(5.26) - (5.29)

    global fr_size fft_size fr_count fs bit_res
	global freq_hz  freq_bark  Abs_thr

		TM_above_thres = tone_masker.*(tone_masker>Abs_thr);
		NM_above_thres = noise_masker.*(noise_masker>Abs_thr);
		
		% The remaining maskers must now be checked to see if any are
		% within a critical band.  If they are, then only the strongest
		% one matters.  The other can be set to zero.
		% go through masker list
		for j = 1 : length(Abs_thr),
	           toneFound=0;
	           noiseFound=0;
           % was a tone or noise masker found?
           if (TM_above_thres(j)>0)
              toneFound=1;
          end
		  if (NM_above_thres(j)>0)
              noiseFound=1;
          end
           % if either masker found
           if (toneFound | noiseFound)
              masker_loc_barks = freq_bark(j);
              % determine low and high thresholds of critical band
              crit_bw_low  = masker_loc_barks-0.5;
              crit_bw_high = masker_loc_barks+0.5;
              % determine what indices these values correspond to
              low_loc  = max(find(freq_bark<crit_bw_low));
              if (isempty(low_loc))
                 low_loc=1;
             else
                 low_loc=low_loc+1;
             end
		         high_loc = max(find(freq_bark<crit_bw_high));
              
              % At this point, we know the location of a masker and its
              % critical band.  Depending on which type of masker it is,
              % browse through and eliminate the maskers within the critical band that are lower.
              for k=low_loc:high_loc,
              		if (toneFound)
						% find other tone maskers in critical band
						if ((TM_above_thres(j) < TM_above_thres(k)) & (k ~= j)),
							TM_above_thres(j)=0;
							break;
						elseif (k ~= j)	
							TM_above_thres(k)=0;
						end
						% find noise maskers in critical band
						if (TM_above_thres(j) < NM_above_thres(k)),
							TM_above_thres(j)=0;
							break;
                        else
							NM_above_thres(k)=0;
                        end
                        
                    elseif (noiseFound)
						% find other noise maskers in critical band
						if ((NM_above_thres(j) < NM_above_thres(k)) & (k ~= j)),
							NM_above_thres(j)=0;
							break;
						elseif (k ~= j)	
							NM_above_thres(k)=0;
						end
						% find tone maskers in critical band
						if (NM_above_thres(j) < TM_above_thres(k)),
							NM_above_thres(j)=0;
							break;
                        else
							TM_above_thres(k)=0;
                        end
                    else
						disp('ERROR');
                    end
                end
            end
        end



%--------------------------------------------------------------------------
% Step-4: Calculation of individual masking thresholds 
%--------------------------------------------------------------------------

function [Thr_TM, Thr_NM] = psy_step_4( P_TM_th, P_NM_th )               % This function uses Eq.(5.30) - (5.32)

	global freq_hz  freq_bark  Abs_thr
% THR = [];
	Thr_TM = zeros(1,length(P_TM_th));
	% Go through the tone list
	for k = find(P_TM_th),
       % determine the masking threshold around the tone masker
       % CALL function 5: mask_threshold
       [thres, start] = mask_threshold(1,k,P_TM_th(k),freq_bark);            %%Eq. (5.30) ---->>>
       % add the power of the threshold to temp in the proper frequency range
       Thr_TM(start:start+length(thres)-1) = Thr_TM(start:start+length(thres)-1)+10.^(0.1.*thres);
%        THR = [THR; thres];
	end
% 	figure, plot(THR)
	Thr_NM = zeros(1,length(P_NM_th));
	% go through noise list
	for k = find(P_NM_th)
       % determine the masking threshold around the noise masker
       % CALL function 5: mask_threshold
       [thres, start] = mask_threshold(0,k,P_NM_th(k),freq_bark);        %%Eq. (5.32) ---->>>
       % add the power of the threshold to temp in the proper frequency range
       Thr_NM(start:start+length(thres)-1) = Thr_NM(start:start+length(thres)-1)+10.^(0.1.*thres);
	end

    
%************************************************************************ SUBFUNCTIONS BEGIN---->>>>>>>
	%------------------------------------------------------------------------------->>>>>>> Subfunction-4(a).I
		function [threshold, start] = mask_threshold(type, j, P, bark)
		% mask_threshold returns an array of the masked threshold in dB SPL that
		% results around a mask located at a frequency bin (i.e., in 
		% discrete terms).  It also returns a starting index for this threshold,
		% which is discussed later.
		%
		% The user should also supply the power spectral density and the related Bark
		% spectrum so that all calculations can be made. Note also that two
		% different threshold are possible, so the user should specify:
		%
		%  type = 0      threshold = NOISE threshold
		%  type = 1      threshold = TONE  threshold
		%
		% This thresholding is determined in a range from -3 to +8 Barks
		% from the mask. (This is why a bark spectrum is needed.)  In case you
		% would like to overlay different thresholds, you need to know where each
		% one actually starts.  Thus, the starting bin for the threshold is also
		% returned.
		
		% determine where masker is in barks
		maskerloc=bark(j);
		
		% set up range of the resulting function in barks
		low=maskerloc-3;
		high=maskerloc+8;
		% in discrete bins
		lowbin=max(find(bark<low));
		
		if (isempty(lowbin))
           lowbin = 1;
       end
		highbin=max(find(bark<high));
		
		% calculate spreading function
		SF = spreading_function(j, P, lowbin, highbin, bark);
		
		if (type==0)
           % calculate noise threshold
           threshold=P-.175*bark(j)+SF-2.025;
		else
           % calculate tone threshold
           threshold=P-.275*bark(j)+SF-6.025;
		end
		
		% finally, note that the lowest value in threshold corresponds
		% to the frequency bin at lowbin.
		start=lowbin;
		
		
		% ------------------------------------------------------------------------
		function spread = spreading_function(masker_bin, power, low, high, bark)      %%% Eq. (5.31) ---->>>>
        
			masker_bark=bark(masker_bin);
			for i=low:high,
               maskee_bark=bark(i);
               deltaz=maskee_bark-masker_bark;
               if ((deltaz>=-3.5) & (deltaz<-1))
                  spread(i-low+1)=17*deltaz-0.4*power+11;
               elseif ((deltaz>=-1) & (deltaz<0))
                  spread(i-low+1)=(0.4*power+6)*deltaz;
               elseif ((deltaz>=0) & (deltaz<1))
                  spread(i-low+1)=-17*deltaz;
               elseif ((deltaz>=1) & (deltaz<8.5))
                  spread(i-low+1)=(0.15*power-17)*deltaz-0.15*power;
               end
			end
            
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Step-5: Calculation of global masking thresholds  
%--------------------------------------------------------------------------
% Global_threshold takes the absolute threshold of hearing as well as the
% spectral densities of noise and tones to determine the overall global
% masking threshold.  This method assumes that the effects of masking
% are additive, so the masks of all maskers and the absolute threshold
% are added together.

function [Thr_global] = psy_step_5( Thr_TM, Thr_NM )                       % This function uses Eq.(5.33)

	global freq_hz  freq_bark  Abs_thr
    
	temp = Thr_TM + Thr_NM;
	% finally, add the power of the absolute hearing threshold to the list
	for k = 1 : length(Abs_thr),
       temp(k)=temp(k)+10.^(0.1.*Abs_thr(k));       %Eq. (5.33)
	end
	Thr_global = temp;      % Note this is not in dB
    