[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020b+-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![GNU Octave](https://img.shields.io/badge/GNU%20Octave-8+-blue.svg)](https://octave.org)

# Dendritic Neighborhood Plasticity Model (v2.0)

MATLAB / GNU Octave implementation of a computational model showing how the state of neighbouring synapses on a dendritic branch determines whether an identical stimulus produces LTP, LTD or no change at a target synapse.

## Model

Each of the `N = 21` synapses on a branch segment (1 target and 20 neighbours) sits on a spine head. The spine head is coupled through a spine-neck conductance to a shared dendritic compartment. The model has two mechanisms:

1. **Voltage-mediated cooperativity.** Co-active neighbours depolarize the branch. This relieves the Mg²⁺ block (Jahr & Stevens, 1990) of NMDA receptors in the target spine and raises its calcium.
2. **A conserved branch-level resource pool `R`.** LTP draws resource from `R` into the synaptic weights, and LTD returns it:

```
dw_i/dt = eta_LTP [Ca_i - theta_LTP]_+ (R/R0)(1 - w_i/w_max) - eta_LTD [Ca_i - theta_LTD]_+ w_i
dR/dt   = -sum_i dw_i/dt + (R0 - R)/tau_R
```

`R + Σ w_i` is conserved on time scales shorter than `tau_R`. This gives competition between potentiating synapses and normalizes the total weight of the branch.

The conductances are calibrated so that a single input produces a ~17 mV spine-head EPSP and a ~1.4 mV branch EPSP.

### Changes from v1.0 (journal revision)
- Spine compartments with neck resistance, calibrated EPSP amplitudes, and the Jahr–Stevens Mg²⁺ block
- Conserved resource pool (LTP: R → w, LTD: w → R), with LTD proportional to `w` and soft-bounded LTP
- Depression process active for all Ca > θ_LTD (Graupner–Brunel-type rule); no hard resource threshold
- Slow expression of weight changes in the conductances (`tau_E`)
- Vectorized simulation of many conditions in parallel (rows of `p.stim_strengths`)

## Files

| File | Description |
|------|-------------|
| `params_default.m` | Default parameters, with units and references |
| `model_odes.m` | Right-hand side of the model, vectorized over conditions × synapses |
| `spine_voltage.m` | Quasi-steady-state spine-head voltages (Newton's method) |
| `mg_block.m` | Jahr–Stevens Mg²⁺ block (or a fixed block for ablations) |
| `stim_protocol.m` | Presynaptic drive (pulse times, strengths, neighbour delay) |
| `run_simulation.m` | Forward-Euler integration; summary statistics and traces |
| `make_S.m` | Builds stimulation rows: target + K co-active neighbours |
| `generate_all_figures.m` | Reproduces every figure and logs all values quoted in the paper |
| `generate_main_figures.m`, `generate_supp_figures.m` | Main figures 1–7 and supplementary figures S1–S7 |
| `convergence_check.m` | Time-step convergence table (Supplementary Table S1) |
| `figure_defaults.m`, `panel_label.m`, `ref_line.m`, `draw_box.m`, `two_slope_map.m`, `set_cbar_ticks.m`, `parula_like.m`, `corr_simple.m`, `ifelse_str.m`, `save_figure.m` | Plotting helpers (portable between MATLAB and Octave) |

## Quick start

```matlab
p = params_default();
p.stim_strengths = make_S(p.N_syn, 0.5, [0 6 12], 0.5);   % target alone, +6, +12 co-active neighbours
[t, rec] = run_simulation(p, @stim_protocol, struct('record', true, 'verbose', true));
% rec.dw(:,1) -> approximately [-0.001; -0.048; +0.210]  (no change, LTD, LTP)

generate_all_figures   % about 20 min; writes figures_main/, figures_supp/, results_log.txt
```

## Citation

> Borjkhani M, Borjkhani H, Sharif MA. Dendritic Neighborhood State Controls Synaptic Plasticity Outcomes: A Computational Model of Local Gating Mechanisms. *Journal of Computational Neuroscience* (under revision).

## License

MIT License — see [LICENSE](LICENSE).

## Author

Mehdi Borjkhani
International Centre for Translational Eye Research (ICTER)
Institute of Physical Chemistry, Polish Academy of Sciences, Warsaw, Poland
