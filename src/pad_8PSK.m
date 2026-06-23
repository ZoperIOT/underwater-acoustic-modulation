function [waveform, info] = pad_8PSK(bits, options)
%PAD_8PSK Generate a pulse-shaped 8PSK waveform (historical name retained).
if nargin < 1 || isempty(bits), bits = randi([0 1], 1, 255); end
if nargin < 2, options = struct(); end
options = auc.apply_defaults(options, auc.common_options());
auc.validate_common(options);
bits = auc.validate_bits(bits);
symbols = auc.psk_symbols(bits, 8, options.phaseOffset);
baseband = auc.shape_symbols(symbols, options);
waveform = auc.passband(baseband, options);
info = auc.make_info('8PSK', bits, symbols, baseband, options);
end
