# 水声通信信号调制 / Underwater Acoustic Signal Modulation

[![Release](https://img.shields.io/github/v/release/ZoperIOT/underwater-acoustic-modulation?display_name=tag&color=0b7285)](https://github.com/ZoperIOT/underwater-acoustic-modulation/releases)
[![License](https://img.shields.io/github/license/ZoperIOT/underwater-acoustic-modulation?color=0b7285)](LICENSE)
[![Last commit](https://img.shields.io/github/last-commit/ZoperIOT/underwater-acoustic-modulation?color=0b7285)](https://github.com/ZoperIOT/underwater-acoustic-modulation/commits/main)

一个面向**水声通信发射端**的 MATLAB 调制工具包：从信息比特生成可播放、可写入 WAV 的声学通带波形。它适合快速搭建水池、近岸或换能器台架实验的发射信号，而不是一个包含完整接收机的系统。

[English documentation](README_EN.md) · [查看 Release](https://github.com/ZoperIOT/underwater-acoustic-modulation/releases) · [快速开始](#快速开始)

![项目总览：从比特到水声实验](docs/images/project-overview.svg)

## 你能用它做什么

- 用 BPSK、QPSK、8PSK、QAM、DSSS 或 OFDM 生成归一化实值通带波形。
- 调整采样率、载波频率、符号率和根升余弦脉冲成形参数。
- 输出标准 `.wav` 文件，连接 DAC、功放和换能器开展声学实验。
- 通过统一的 `generate_signal` 入口快速切换调制方式。

> **范围说明**：本仓库只实现发射波形生成；解调、同步、信道估计和 BER 计算不在当前范围内。

## 支持的调制方式

| 函数 | 调制方式 | 默认载波 / 速率 |
| --- | --- | --- |
| `BPSK` | BPSK | 10 kHz / 200 Baud |
| `QPSK` | QPSK | 10 kHz / 200 Baud |
| `pad_8PSK` | 8PSK | 10 kHz / 200 Baud |
| `QAMtrain` | 方形 QAM（默认 16QAM） | 10 kHz / 200 Baud |
| `DSSS` | DSSS-BPSK（m 序列扩频） | 11 kHz / 37.8 bit/s |
| `OFDM` | 导频辅助 QPSK-OFDM | 10 kHz / 7.5 Hz 子载波间隔 |

## 快速开始

```matlab
addpath('src');

% 生成 128 bit 的 QPSK 水声发射波形。
bits = randi([0 1], 1, 128);
[waveform, info] = QPSK(bits);

% 显式保存为 96 kHz WAV 文件。
audiowrite('qpsk_10k.wav', waveform, info.sampleRate);

% 通过统一入口切换调制方式。
[ofdmWaveform, ofdmInfo] = generate_signal('ofdm', [], ...
    struct('carrierFrequency', 12000, 'numberOfOFDMSymbols', 10));
```

## 输出长什么样？

以下图像由仓库内的 QPSK 示例生成，展示了实际要送入播放链路的通带波形、归一化频谱，以及映射前的理想星座点。

![QPSK waveform, spectrum, and constellation](examples/output/qpsk_diagnostics.png)

在 MATLAB 中重新生成全部诊断图：

```matlab
run('examples/generate_visualizations.m')
```

运行 `examples/generate_examples.m` 可生成每一种调制方式的 WAV 文件；音频文件会写入 `examples/output/`，但不会提交到 Git。

## 参数示例

参数以 MATLAB 标量结构体传入；未传入字段采用默认值。

```matlab
% BPSK：12 kHz 载波、400 Baud、滚降系数 0.5。
opt = struct('sampleRate', 96000, 'carrierFrequency', 12000, ...
             'symbolRate', 400, 'rolloff', 0.5);
[w, meta] = BPSK(randi([0 1], 1, 256), opt);

% 64QAM。
[w, meta] = QAMtrain(randi([0 1], 1, 600), struct('order', 64));

% DSSS：每个信息比特使用 127 个 chip。
[w, meta] = DSSS(randi([0 1], 1, 32), ...
    struct('spreadingFactor', 127, 'carrierFrequency', 11000));
```

单载波方式需满足 `sampleRate / symbolRate` 为整数；DSSS 需满足 `sampleRate / (symbolRate * spreadingFactor)` 为整数。QPSK、8PSK 与 QAM 的输入比特数必须能被每符号比特数整除。OFDM 会自动在末帧补零，并将数量记录在 `info.paddingBits` 中。

## 声学实验提示

默认配置（96 kHz 采样、10 kHz 载波）可作为起点。实际部署前，请按换能器带宽、声道、功放和 DAC 的满量程范围校准载波频率、符号率与输出幅度。生成的波形是范围在 `[-1, 1]` 的双极性浮点信号；若设备需要 `uint16` 或其他格式，应在写入设备前按硬件规范转换。

## 项目结构

```text
src/                       调制函数与内部工具函数
data/s_Gold_data.mat       原始工程附带的 Gold 码参考数据
examples/generate_examples.m       生成各制式 WAV 文件
examples/generate_visualizations.m 生成 README 中的诊断图
examples/output/           可复现的 PNG 预览与本地 WAV 输出
docs/images/               README 项目总览图
```

## 依赖与许可

代码仅使用 MATLAB 基础数值函数；根升余弦滤波器已在仓库中实现，因此不依赖 Communications Toolbox。项目采用 [MIT License](LICENSE)。
