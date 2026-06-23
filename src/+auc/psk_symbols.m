function symbols = psk_symbols(bits, order, phaseOffset)
%PSK_SYMBOLS Map binary input to unit-power M-PSK symbols.
bitsPerSymbol = log2(order);
if bitsPerSymbol ~= round(bitsPerSymbol)
    error('auc:InvalidPSKOrder', 'PSK order must be a power of two.');
end
values = auc.bits_to_integers(bits, bitsPerSymbol);
symbols = exp(1i * (phaseOffset + 2 * pi * values / order)).';
end
