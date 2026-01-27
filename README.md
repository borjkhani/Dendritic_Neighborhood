[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020b+-blue.svg)](https://www.mathworks.com/products/matlab.html)


# Dendritic Neighborhood Plasticity Model

MATLAB implementation of a computational model demonstrating how the state of neighboring synapses on dendritic branches controls plasticity outcomes at individual synapses.

## Overview

This model combines two key mechanisms:
1. **Voltage-dependent NMDA receptor gating** — neighboring synapses influence local calcium influx through dendritic depolarization
2. **Shared branch-level resource dynamics** — synapses compete for molecular machinery required for plasticity (PRPs, local translation capacity)

## Key Features

- Supports N ≥ 2 synapses per dendritic branch
- Calcium-threshold plasticity rule (BCM-like)
- Configurable ablation studies (toggle Mg²⁺-block, resource dynamics)
- Flexible stimulation protocols with timing control
- Generates publication-quality figures

## Files

| File | Description |
|------|-------------|
| `model_odes.m` | Core differential equations for the model |
| `params_default.m` | Default parameter values with physiological references |
| `run_simulation.m` | Main simulation driver with state recording |
| `stim_protocol.m` | Flexible stimulation protocol generator |
| `generate_all_figures_polished.m` | Reproduces all manuscript figures |

## Quick Start
```matlab
% Run with default parameters
p = params_default();
[t, sol, rec] = run_simulation(p, @stim_protocol, true);

% Generate all figures
generate_all_figures_polished
```

## Citation

If you use this code, please cite:

> Borjkhani M, Borjkhani H, Sharif MA. Dendritic Neighborhood State Controls Synaptic Plasticity Outcomes: A Computational Model of Local Gating Mechanisms. *Journal of Computational Neuroscience* (2025).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Mehdi Borjkhani  
International Centre for Translational Eye Research (ICTER)  
Polish Academy of Sciences, Warsaw, Poland
