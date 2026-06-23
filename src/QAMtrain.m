function [waveform, info] = QAMtrain(bits, options)
%QAMTRAIN Generate a pulse-shaped square-QAM passband waveform.
if nargin < 1 || isempty(bits), bits = randi([0 1], 1, 256); end
if nargin < 2, options = struct(); end
defaults = auc.common_options(); defaults.order = 16;
options = auc.apply_defaults(options, defaults);
auc.validate_common(options);
bits = auc.validate_bits(bits);
symbols = auc.qam_symbols(bits, options.order);
baseband = auc.shape_symbols(symbols, options);
waveform = auc.passband(baseband, options);
info = auc.make_info(sprintf('%dQAM', options.order), bits, symbols, baseband, options);
end
