%GENERATE_EXAMPLES Create one WAV file for every supported transmit waveform.
rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'src'));
outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
if ~exist(outputDir, 'dir'), mkdir(outputDir); end
rng(7);
formats = {'bpsk', 'qpsk', '8psk', 'qam', 'dsss', 'ofdm'};
for index = 1:numel(formats)
    [waveform, info] = generate_signal(formats{index});
    audiowrite(fullfile(outputDir, [formats{index} '.wav']), waveform, info.sampleRate);
    fprintf('%-10s %.3f s  %d Hz\n', info.modulation, info.durationSeconds, info.sampleRate);
end
