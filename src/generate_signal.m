function [waveform, info] = generate_signal(modulation, bits, options)
%GENERATE_SIGNAL Unified entry point for all transmit-side modulators.
if nargin < 2, bits = []; end
if nargin < 3, options = struct(); end
switch lower(char(modulation))
    case 'bpsk'
        [waveform, info] = BPSK(bits, options);
    case 'qpsk'
        [waveform, info] = QPSK(bits, options);
    case {'8psk', 'pad_8psk'}
        [waveform, info] = pad_8PSK(bits, options);
    case {'qam', 'qamtrain'}
        [waveform, info] = QAMtrain(bits, options);
    case {'dsss', 'dsss-bpsk'}
        [waveform, info] = DSSS(bits, options);
    case 'ofdm'
        [waveform, info] = OFDM(bits, options);
    otherwise
        error('generate_signal:UnknownModulation', 'Unsupported modulation: %s', char(modulation));
end
end
