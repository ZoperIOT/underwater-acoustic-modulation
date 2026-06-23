function [waveform, info] = QPSK(bits, options)
%QPSK Generate a pulse-shaped QPSK underwater-acoustic passband waveform.
if nargin < 1 || isempty(bits), bits = randi([0 1], 1, 256); end
if nargin < 2, options = struct(); end
defaults = auc.common_options(); defaults.phaseOffset = pi / 4;
options = auc.apply_defaults(options, defaults);
auc.validate_common(options);
bits = auc.validate_bits(bits);
symbols = auc.psk_symbols(bits, 4, options.phaseOffset);
baseband = auc.shape_symbols(symbols, options);
waveform = auc.passband(baseband, options);
info = auc.make_info('QPSK', bits, symbols, baseband, options);
end
