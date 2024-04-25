function [name,sig,fs]=loadsig(sigdir)
%LOADSIG load signal in one of known formats
%
% USAGE:
%   [name,sig,fs]=loadsig(sigdir)
%
% where:
%   sigdir is the starting directory for the UI
%   fs is the sampling frequency
%
% Can load .wav, .au or .snd formats at present

% renamed from loadSignal for V2.1 release
% SJW/MPC 11/6/99

name=[];
sig=[];
fs=0;
savedir=pwd;
cd(sigdir)
if strcmp(computer,'PCWIN')
  [filename,dirname] = uigetfile(fullfile(sigdir,'*.*'),'New Signal');
else
  [filename,dirname] = uigetfile(fullfile(sigdir,'*'),'New Signal');
end
cd(savedir)
if filename
  [path,name,ext,ver] = fileparts(filename);
  switch ext
  case '.wav'
    [sig,fs]=wavread(strcat(dirname,filename));
  case '.au'
    [sig,fs]=auread(strcat(dirname,filename));
  case '.snd'
    [sig,fs]=auread(strcat(dirname,filename));         
  otherwise
    msgbox('loadsig: Signal file format is not one of .wav, .au or .snd');
    name=[];
  end
  if ~sig
    warndlg(['loadsig: Unable to load signal ' name]);
  else
    sig=sig(:);
  end  
end


