function h = rrc_filter(beta, span, samplesPerSymbol)
%RRC_FILTER Unit-energy root-raised-cosine FIR impulse response.
% This implementation avoids a Communications Toolbox dependency.
t = (-span/2 : 1/samplesPerSymbol : span/2);
h = zeros(size(t));
for index = 1:numel(t)
    x = t(index);
    if abs(x) < 1e-12
        h(index) = 1 + beta * (4/pi - 1);
    elseif beta > 0 && abs(abs(x) - 1/(4*beta)) < 1e-10
        h(index) = beta / sqrt(2) * ((1 + 2/pi) * sin(pi/(4*beta)) + ...
            (1 - 2/pi) * cos(pi/(4*beta)));
    elseif beta == 0
        h(index) = sin(pi*x) / (pi*x);
    else
        h(index) = (4*beta/pi) * (cos((1+beta)*pi*x) + ...
            sin((1-beta)*pi*x)/(4*beta*x)) / (1 - (4*beta*x)^2);
    end
end
h = h / sqrt(sum(abs(h).^2));
end
