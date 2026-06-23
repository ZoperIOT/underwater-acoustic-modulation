function bits = validate_bits(bits)
%VALIDATE_BITS Return a binary row vector or report invalid input.
if ~isnumeric(bits) && ~islogical(bits)
    error('auc:InvalidBits', 'Bits must be numeric or logical values.');
end
bits = double(bits(:).');
if isempty(bits) || any(bits ~= 0 & bits ~= 1) || any(~isfinite(bits))
    error('auc:InvalidBits', 'Bits must be a nonempty vector containing only 0 and 1.');
end
end
