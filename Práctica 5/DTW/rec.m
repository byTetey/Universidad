
fs = 16000;
beep=audioread('beep.wav');
sound(beep,fs);

recObj = audiorecorder(fs,16,1);
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
myRecording = getaudiodata(recObj);

% Plot the waveform.
plot(myRecording);

