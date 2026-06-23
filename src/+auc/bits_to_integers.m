function values = bits_to_integers(bits, bitsPerSymbol)
%BITS_TO_INTEGERS Map MSB-first binary groups to nonnegative integers.
if mod(numel(bits), bitsPerSymbol) ~= 0
    error('auc:IncompleteSymbol', 'Input length must be divisible by %d.', bitsPerSymbol);
end
groups = reshape(bits, bitsPerSymbol, []).';
values = groups * (2 .^ (bitsPerSymbol - 1:-1:0)).';
end
