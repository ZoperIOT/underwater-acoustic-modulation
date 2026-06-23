# 水声通信信号调制 / Underwater Acoustic Signal Modulation

一套面向水声通信发射端的 MATLAB 调制函数。项目只生成发射波形，**不包含解调、同步、信道估计或误码率计算**。默认参数适合 96 kHz 采样、10 kHz 载波的水声实验起点；实际海试前请结合换能器带宽、声道和功放/DAC 标定调整。

[English documentation](README_EN.md)

## 支持的调制方式

| 函数 | 调制方式 | 默认载波 / 符号率 |
| --- | --- | --- |
| `BPSK` | BPSK | 10 kHz / 200 Baud |
| `QPSK` | QPSK | 10 kHz / 200 Baud |
| `pad_8PSK` | 8PSK | 10 kHz / 200 Baud |
| `QAMtrain` | 方形 QAM（默认 16QAM） | 10 kHz / 200 Baud |
| `DSSS` | DSSS-BPSK（m 序列扩频） | 11 kHz / 37.8 bit/s |
| `OFDM` | 导频辅助 QPSK-OFDM | 10 kHz / 7.5 Hz 子载波间隔 |

所有函数返回 `waveform`（行向量、`double`、归一化至 `[-1, 1]`）和 `info`（实际使用的比特、参数、基带符号等元数据）。函数不会画图、清空工作区或写文件。

## 快速开始

```matlab
addpath('src');

% 生成 128 bit 的 QPSK 声学发射波形
bits = randi([0 1], 1, 128);
[waveform, info] = QPSK(bits);
audiowrite('qpsk_10k.wav', waveform, info.sampleRate);

% 一行切换调制方式
[ofdmWaveform, ofdmInfo] = generate_signal('ofdm', [], ...
    struct('carrierFrequency', 12000, 'numberOfOFDMSymbols', 10));
```

运行 `examples/generate_examples.m` 可生成各制式的 WAV 文件。输出目录为 `examples/output/`（已被 Git 忽略）。

## 参数示例

参数用结构体传入；未传字段使用默认值。

```matlab
% BPSK：12 kHz 载波、400 Baud、滚降系数 0.5
opt = struct('sampleRate', 96000, 'carrierFrequency', 12000, ...
             'symbolRate', 400, 'rolloff', 0.5);
[w, meta] = BPSK(randi([0 1], 1, 256), opt);

% 64QAM
[w, meta] = QAMtrain(randi([0 1], 1, 600), struct('order', 64));

% DSSS：每比特 127 个 chip
[w, meta] = DSSS(randi([0 1], 1, 32), ...
    struct('spreadingFactor', 127, 'carrierFrequency', 11000));
```

`sampleRate / symbolRate`（或 DSSS 的 `sampleRate / (symbolRate * spreadingFactor)`）必须是整数。QPSK、8PSK、QAM 的输入比特长度必须可被每符号比特数整除。OFDM 会在一个帧的末尾自动补零，并把补零数量写入 `info.paddingBits`。

## 项目结构

```text
src/                 调制函数与内部工具函数
data/s_Gold_data.mat 原始工程附带的 Gold 码数据（可选参考数据）
examples/            最小可运行示例
```

## 依赖与注意事项

代码只使用 MATLAB 基础数值函数；根升余弦滤波器已在项目内实现，因此不依赖 Communications Toolbox。发射端一般应保持双极性浮点波形；如果你的 DAC 需要 `uint16` 或有特定满量程，请在写入设备前按设备规范转换，不要直接复用旧脚本里的固定幅度值。

## 许可证

MIT License，详见 [LICENSE](LICENSE)。
