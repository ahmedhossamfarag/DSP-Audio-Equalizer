filename = 'Fanfare60.wav';
newname = 'Fanfare60New.wav';
bassG = 0;
midG  = 1;
tribleG = 1;

%% Audio Signal Loading
[y,Fs] = audioread(filename);

%% Preprocessing
A = max(y);
L = length(y);
t = (0:L-1)/Fs;
ynorm = y / A;

%% DFT
a = fftshift(fft(ynorm));
f = Fs/L*(-L/2:L/2-1);

%% Equalizer
bassW = 250;
tribleW = 4e3;

%% Gain Adjustment
a_ = a;
f_ = abs(f);

bassB = f_ <= bassW;
midB = f_ > bassW & f_ < tribleW;
tribleB = f_ >= tribleW;

a_(bassB) = a_(bassB) * bassG;
a_(midB) = a_(midB) * midG;
a_(tribleB) = a_(tribleB) * tribleG;

%% IDFT
y_ = ifft(ifftshift(a_));

%% Reconstruction
y_ = y_ * A;

%% Output
audiowrite(newname, y_, Fs)
%sound(y_, Fs)

%% Comparison
subplot(3, 1, 1)
plot(t, y);
subplot(3, 1, 2)
plot(t, y_);
subplot(3, 2, 5)
plot(f, abs(a));
subplot(3, 2, 6)
plot(f, abs(a_));
rmseValue = rmse(y, y_);
display(rmseValue)
snrValue = snr(y, y_ -  y);
display(snrValue)
