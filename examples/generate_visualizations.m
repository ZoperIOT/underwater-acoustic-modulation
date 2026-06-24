%GENERATE_VISUALIZATIONS Create README-ready QPSK diagnostic figures.
% Outputs a waveform, spectrum, and ideal constellation into examples/output/.
rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'src'));
outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
if ~exist(outputDir, 'dir'), mkdir(outputDir); end

rng(7);
options = struct('sampleRate', 96000, 'carrierFrequency', 10000, ...
    'symbolRate', 200, 'rolloff', 0.8, 'filterSpan', 10);
[waveform, info] = QPSK(randi([0 1], 1, 256), options);

figure('Color', 'w', 'Position', [100 100 1320 410]);

subplot(1, 3, 1);
startSample = min(round(0.05 * info.sampleRate) + 1, numel(waveform));
sampleCount = min(round(0.025 * info.sampleRate), numel(waveform) - startSample + 1);
t = (0:sampleCount - 1) / info.sampleRate * 1e3;
plot(t, waveform(startSample:startSample + sampleCount - 1), ...
    'Color', [0.03 0.36 0.63], 'LineWidth', 1.1);
grid on; box off;
xlabel('Time (ms)'); ylabel('Amplitude');
title('QPSK passband waveform');
xlim([t(1), t(end)]); ylim([-1.1, 1.1]);

subplot(1, 3, 2);
nfft = 2^nextpow2(numel(waveform));
window = 0.5 - 0.5 * cos(2 * pi * (0:numel(waveform)-1) / (numel(waveform)-1));
spectrum = fftshift(fft(waveform .* window, nfft));
f = ((-nfft/2):(nfft/2-1)) / nfft * info.sampleRate / 1e3;
powerDb = 20 * log10(abs(spectrum) / max(abs(spectrum)) + eps);
plot(f, powerDb, 'Color', [0.89 0.31 0.16], 'LineWidth', 1.1);
grid on; box off;
xlabel('Frequency (kHz)'); ylabel('Normalized magnitude (dB)');
title('Transmit spectrum');
xlim([0, 20]); ylim([-80, 2]);

subplot(1, 3, 3);
scatter(real(info.symbols), imag(info.symbols), 72, [0.06 0.55 0.52], 'filled');
grid on; axis equal; box off;
xlabel('In-phase'); ylabel('Quadrature');
title('Ideal QPSK constellation');
xlim([-1.25, 1.25]); ylim([-1.25, 1.25]);

sgtitle(sprintf('Example output: %s, %.0f kHz carrier, %.0f baud', ...
    info.modulation, info.carrierFrequency / 1e3, info.symbolRate), 'FontWeight', 'bold');
print(gcf, fullfile(outputDir, 'qpsk_diagnostics.png'), '-dpng', '-r180');
close(gcf);
fprintf('Wrote %s\n', fullfile(outputDir, 'qpsk_diagnostics.png'));
