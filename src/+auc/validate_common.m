function validate_common(options)
%VALIDATE_COMMON Validate shared single-carrier waveform parameters.
if ~isscalar(options.sampleRate) || options.sampleRate <= 0 || ...
        ~isscalar(options.symbolRate) || options.symbolRate <= 0
    error('auc:InvalidRate', 'sampleRate and symbolRate must be positive scalars.');
end
sps = options.sampleRate / options.symbolRate;
if abs(sps - round(sps)) > 1e-10 || sps < 2
    error('auc:InvalidSamplesPerSymbol', 'sampleRate/symbolRate must be an integer of at least 2.');
end
if ~isscalar(options.carrierFrequency) || options.carrierFrequency <= 0 || ...
        options.carrierFrequency >= options.sampleRate / 2
    error('auc:InvalidCarrier', 'carrierFrequency must be between 0 and Nyquist.');
end
if ~isscalar(options.rolloff) || options.rolloff < 0 || options.rolloff > 1 || ...
        ~isscalar(options.filterSpan) || options.filterSpan < 2 || options.filterSpan ~= round(options.filterSpan)
    error('auc:InvalidFilter', 'rolloff must be in [0,1] and filterSpan must be an integer >= 2.');
end
end
