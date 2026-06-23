function [waveform, info] = DSSS(bits, options)
%DSSS Generate a direct-sequence spread-spectrum BPSK passband waveform.
if nargin < 1 || isempty(bits), bits = randi([0 1], 1, 32); end
if nargin < 2, options = struct(); end
defaults = auc.common_options();
defaults.carrierFrequency = 11000;
defaults.symbolRate = 96000 / (20 * 127);
defaults.rolloff = 0.5;
defaults.spreadingFactor = 127;
defaults.pnState = 1;
options = auc.apply_defaults(options, defaults);
bits = auc.validate_bits(bits);
if options.spreadingFactor < 3 || mod(log2(options.spreadingFactor + 1), 1) ~= 0
    error('DSSS:InvalidSpreadingFactor', 'spreadingFactor must have the form 2^n - 1.');
end
bitRate = options.symbolRate;
options.symbolRate = bitRate * options.spreadingFactor;
auc.validate_common(options);
order = round(log2(options.spreadingFactor + 1));
pn = 2 * mgen(order, options.pnState, numel(bits) * options.spreadingFactor) - 1;
chips = repelem(2 * bits - 1, options.spreadingFactor) .* pn;
baseband = auc.shape_symbols(chips, options);
waveform = auc.passband(baseband, options);
info = auc.make_info('DSSS-BPSK', bits, chips, baseband, options);
info.spreadingFactor = options.spreadingFactor;
info.pnSequence = pn;
info.bitRate = bitRate;
info.chipRate = options.symbolRate;
end
