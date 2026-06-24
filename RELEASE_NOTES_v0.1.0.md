# Underwater Acoustic Modulation v0.1.0

The first public release of a MATLAB transmit-side modulation toolkit for underwater acoustic communication experiments.

## Highlights

- Generate normalized real passband waveforms for BPSK, QPSK, 8PSK, square QAM, DSSS-BPSK, and pilot-aided QPSK-OFDM.
- Use a common options interface to tune sampling rate, carrier frequency, symbol rate, pulse shaping, and modulation-specific settings.
- Export reference `.wav` files through `examples/generate_examples.m`.
- Reproduce the waveform, spectrum, and constellation preview with `examples/generate_visualizations.m`.

## Scope

This release covers transmit waveform generation. Demodulation, synchronization, channel estimation, and BER analysis are deliberately outside its scope.

## Getting started

See the README for a minimal QPSK example, supported schemes, output diagnostics, and acoustic-experiment guidance.
