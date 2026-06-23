function [waveform, info] = OFDM(bits, options)
%OFDM Generate a pilot-aided QPSK-OFDM underwater-acoustic waveform.
% Transmit-side only: framing, IFFT, cyclic prefix, expansion, upconversion.
if nargin < 1, bits = []; end
if nargin < 2, options = struct(); end
defaults = struct('sampleRate', 96000, 'carrierFrequency', 10000, ...
    'fftSize', 64, 'cyclicPrefixLength', 16, 'subcarrierSpacing', 7.5, ...
    'pilotSpacing', 6, 'pilotValue', 1 + 1i, 'numberOfOFDMSymbols', 6);
options = auc.apply_defaults(options, defaults);
if options.fftSize < 8 || mod(options.fftSize, 2) ~= 0 || ...
        options.cyclicPrefixLength < 0 || options.cyclicPrefixLength >= options.fftSize
    error('OFDM:InvalidFrame', 'fftSize must be even and cyclicPrefixLength must be in [0, fftSize).');
end
oversample = options.sampleRate / (options.fftSize * options.subcarrierSpacing);
if oversample < 1 || abs(oversample - round(oversample)) > 1e-10
    error('OFDM:InvalidSampleRate', 'sampleRate/(fftSize*subcarrierSpacing) must be a positive integer.');
end
if options.carrierFrequency <= 0 || options.carrierFrequency >= options.sampleRate / 2
    error('OFDM:InvalidCarrier', 'carrierFrequency must be between 0 and Nyquist.');
end
active = [-options.fftSize/2:-1, 1:options.fftSize/2];
if options.fftSize == 64, active = active(active >= -26 & active <= 26); end
pilotCarriers = active(1:options.pilotSpacing:end);
dataCarriers = setdiff(active, pilotCarriers, 'stable');
capacity = numel(dataCarriers) * options.numberOfOFDMSymbols * 2;
if isempty(bits)
    bits = randi([0 1], 1, capacity);
else
    bits = auc.validate_bits(bits);
    if numel(bits) > capacity
        error('OFDM:TooManyBits', 'Input has %d bits; one frame carries %d bits.', numel(bits), capacity);
    end
end
paddingBits = capacity - numel(bits);
bitsUsed = [bits, zeros(1, paddingBits)];
qpsk = reshape(auc.psk_symbols(bitsUsed, 4, pi / 4), numel(dataCarriers), []);
bins = zeros(options.fftSize, options.numberOfOFDMSymbols);
bins(mod(pilotCarriers, options.fftSize) + 1, :) = options.pilotValue;
bins(mod(dataCarriers, options.fftSize) + 1, :) = qpsk;
timeSymbols = ifft(bins, options.fftSize, 1);
withCp = [timeSymbols(end-options.cyclicPrefixLength+1:end, :); timeSymbols];
baseband = repelem(reshape(withCp, 1, []), round(oversample));
options.symbolRate = options.subcarrierSpacing;
waveform = auc.passband(baseband, options);
info = auc.make_info('QPSK-OFDM', bits, qpsk(:).', baseband, options);
info.paddingBits = paddingBits;
info.activeSubcarriers = active;
info.pilotSubcarriers = pilotCarriers;
info.dataSubcarriers = dataCarriers;
info.oversampleFactor = round(oversample);
info.subcarrierSpacing = options.subcarrierSpacing;
info.cyclicPrefixLength = options.cyclicPrefixLength;
end
