---
name: "⚡ Performance Telemetry Report"
about: "Provide latency, frametime, or resource overhead metrics"
title: "[PERF] - "
labels: ["performance"]
assignees: []
---

```ini
========================================================================
                   WinAurex PERFORMANCE TELEMETRY
========================================================================
[ METRIC MODE  ] : BENCHMARK COMPARISON
[ STABILITY    ] : ENCOUNTERED DEVIATION
========================================================================
```

### 📈 1. METRICS DEVIATION
> Detail the performance metric that was impacted (e.g., Mouse input delay, FPS 1% lows, LatencyMon spikes, RAM overhead).

### 🛠️ 2. TESTING SUITE & METHODOLOGY
*Specify the software tools and benchmarks used to capture this telemetry:*
- `[ ] LatencyMon (DPC/ISR Latency)`
- `[ ] PresentMon / CapFrameX (Frametimes and 1% lows)`
- `[ ] Windows Performance Toolkit (WPR/WPA analyzer)`
- `[ ] MouseTester (Input polling rate / consistency)`
- `[ ] AIDA64 / MemTest (Memory latency & bandwidth)`

### 📊 3. BEFORE VS. AFTER SYSTEM STATE
| Metric Category | Original Windows State | WinAurex Applied State | Resulting Trend |
|---|---|---|---|
| **DPC Latency Peak** | `e.g., 180 μs` | `e.g., 34 μs` | `Improved` |
| **FPS 1% Lows** | `e.g., 112 FPS` | `e.g., 141 FPS` | `Improved` |
| **RAM Utilization** | `e.g., 4.2 GB` | `e.g., 2.1 GB` | `Optimized` |

### 🔍 4. TELEMETRY DETAILS / EXPLANATION
> Explain the test environment. Detail how to reproduce the performance degradation or DPC spike (e.g., "Occurs under heavy NVMe disk writes when high-performance scheduler is loaded").
```
