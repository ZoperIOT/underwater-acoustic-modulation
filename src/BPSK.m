function [waveform, info] = BPSK(bits, options)
%BPSK Generate a pulse-shaped BPSK underwater-acoustic passband waveform.
if nargin < 1 || isempty(bits), bits = randi([0 1], 1, 256); end
if nargin < 2, options = struct(); end
options = auc.apply_defaults(options, auc.common_options());
auc.validate_common(options);
bits = auc.validate_bits(bits);
symbols = 2 * bits - 1;
baseband = auc.shape_symbols(symbols, options);
waveform = auc.passband(baseband, options);
info = auc.make_info('BPSK', bits, symbols, baseband, options);
end
