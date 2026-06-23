function baseband = shape_symbols(symbols, options)
%SHAPE_SYMBOLS Upsample and root-raised-cosine shape complex symbols.
samplesPerSymbol = round(options.sampleRate / options.symbolRate);
filter = auc.rrc_filter(options.rolloff, options.filterSpan, samplesPerSymbol);
upsampled = zeros(1, numel(symbols) * samplesPerSymbol);
upsampled(1:samplesPerSymbol:end) = symbols;
baseband = conv(upsampled, filter, 'full');
end
