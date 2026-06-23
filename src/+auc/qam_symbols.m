function symbols = qam_symbols(bits, order)
%QAM_SYMBOLS Map binary input to normalized rectangular square-QAM symbols.
side = sqrt(order);
bitsPerAxis = log2(side);
if side ~= round(side) || bitsPerAxis ~= round(bitsPerAxis)
    error('auc:InvalidQAMOrder', 'QAM order must be a square power of two (4, 16, 64...).');
end
values = auc.bits_to_integers(bits, 2 * bitsPerAxis);
iIndex = floor(values / side);
qIndex = mod(values, side);
levels = -(side - 1):2:(side - 1);
symbols = levels(iIndex + 1) + 1i * levels(qIndex + 1);
symbols = (symbols / sqrt(mean(abs(symbols).^2))).';
end
