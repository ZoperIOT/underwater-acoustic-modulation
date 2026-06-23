function waveform = passband(baseband, options)
%PASSBAND Upconvert complex baseband and normalize a real passband signal.
n = 0:numel(baseband)-1;
carrier = exp(1i * 2 * pi * options.carrierFrequency * n / options.sampleRate);
waveform = real(baseband .* carrier);
peak = max(abs(waveform));
if peak > 0, waveform = waveform / peak; end
waveform = double(waveform(:).');
end
