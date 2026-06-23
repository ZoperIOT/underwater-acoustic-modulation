function options = common_options()
%COMMON_OPTIONS Default parameters for single-carrier modulators.
options = struct('sampleRate', 96000, 'carrierFrequency', 10000, ...
    'symbolRate', 200, 'rolloff', 0.8, 'filterSpan', 10, 'phaseOffset', 0);
end
