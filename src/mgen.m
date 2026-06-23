function out = mgen(PN_order, state, N)
%MGEN Generate a binary maximal-length-sequence-style PN sequence.
if ~isscalar(PN_order) || PN_order < 2 || PN_order > 16 || PN_order ~= round(PN_order)
    error('mgen:InvalidOrder', 'PN_order must be an integer from 2 to 16.');
end
if ~isscalar(N) || N < 1 || N ~= round(N)
    error('mgen:InvalidLength', 'N must be a positive integer.');
end
if isscalar(state)
    if state <= 0 || state >= 2^PN_order || state ~= round(state)
        error('mgen:InvalidState', 'Scalar state must be in [1, 2^PN_order-1].');
    end
    register = bitget(uint32(state), PN_order:-1:1);
else
    register = double(state(:).');
    if numel(register) ~= PN_order || any(register ~= 0 & register ~= 1) || ~any(register)
        error('mgen:InvalidState', 'Vector state must be a nonzero binary vector.');
    end
end
tapTable = {[2 1], [3 2], [4 3], [5 3], [6 5], [7 6], [8 6 5 4], ...
    [9 5], [10 7], [11 9], [12 11 10 4], [13 12 11 8], [14 13 12 2], ...
    [15 14], [16 15 13 4]};
taps = tapTable{PN_order - 1};
out = zeros(1, N);
for index = 1:N
    out(index) = register(end);
    feedback = mod(sum(register(taps)), 2);
    register = [feedback, register(1:end-1)];
end
end
