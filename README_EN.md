# Underwater Acoustic Signal Modulation

A MATLAB transmit-side modulation toolkit for underwater acoustic communication experiments. It generates acoustic passband waveforms only; **demodulation, synchronization, channel estimation, and BER calculation are intentionally out of scope**.

The default settings are a practical starting point for experiments using a 96 kHz sampling rate and a 10 kHz carrier. Before deployment, tune the carrier frequency, symbol rate, and output scaling to match the transducer bandwidth, propagation channel, power amplifier, and DAC.

[中文版说明 / Chinese documentation](README.md)

## Supported Modulations

| Function | Modulation | Default carrier / rate |
| --- | --- | --- |
| BPSK | BPSK | 10 kHz / 200 Baud |
| QPSK | QPSK | 10 kHz / 200 Baud |
| pad_8PSK | 8PSK | 10 kHz / 200 Baud |
| QAMtrain | Square QAM (16QAM by default) | 10 kHz / 200 Baud |
| DSSS | DSSS-BPSK with an m-sequence | 11 kHz / 37.8 bit/s |
| OFDM | Pilot-aided QPSK-OFDM | 10 kHz / 7.5 Hz subcarrier spacing |

Every modulator returns a waveform: a real, normalized double row vector in the range [-1, 1], and info: metadata including the actual bits, symbols, baseband waveform, options, and sampling rate.

The functions do not clear the workspace, create figures, or write output files.

## Quick Start

~~~matlab
addpath('src');

% Generate a 128-bit QPSK passband waveform.
bits = randi([0 1], 1, 128);
[waveform, info] = QPSK(bits);

% Save the signal explicitly when needed.
audiowrite('qpsk_10k.wav', waveform, info.sampleRate);

% Use the unified entry point.
[ofdmWaveform, ofdmInfo] = generate_signal('ofdm', [], ...
    struct('carrierFrequency', 12000, 'numberOfOFDMSymbols', 10));
~~~

Run examples/generate_examples.m to create one WAV file for each supported modulation. Files are written to examples/output/, which is ignored by Git.

## Options

Pass a scalar MATLAB struct as the last argument. Omitted fields use the defaults.

~~~matlab
% BPSK at 12 kHz and 400 Baud with a 0.5 roll-off factor.
opt = struct('sampleRate', 96000, 'carrierFrequency', 12000, ...
             'symbolRate', 400, 'rolloff', 0.5);
[w, meta] = BPSK(randi([0 1], 1, 256), opt);

% 64QAM.
[w, meta] = QAMtrain(randi([0 1], 1, 600), struct('order', 64));

% DSSS with 127 chips per information bit.
[w, meta] = DSSS(randi([0 1], 1, 32), ...
    struct('spreadingFactor', 127, 'carrierFrequency', 11000));
~~~

For single-carrier schemes, sampleRate / symbolRate must be an integer. For DSSS, sampleRate / (symbolRate * spreadingFactor) must be an integer. The bit length for QPSK, 8PSK, and QAM must be divisible by the number of bits per symbol. OFDM automatically pads the final frame with zero bits and records the count in info.paddingBits.

## Project Layout

~~~text
src/                 Modulators and internal utilities
data/s_Gold_data.mat Gold-code data included with the original project
examples/            Minimal runnable example
~~~

## Dependencies and Output Scaling

The implementation uses MATLAB base numerical functions only. The root-raised-cosine filter is implemented inside the repository, so Communications Toolbox is not required.

The generated waveform is a bipolar floating-point transmit signal. If your DAC expects uint16, a different full-scale range, or another data format, apply the device-specific conversion immediately before transmission. Do not reuse a fixed amplitude from an older script without checking your hardware's requirements.

## License

Released under the [MIT License](LICENSE).
