

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020b+-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![GNU Octave](https://img.shields.io/badge/GNU%20Octave-8+-blue.svg)](https://octave.org)

# Dendritic Neighborhood Plasticity Model

MATLAB / GNU Octave code for the paper:

> **Borjkhani M, Borjkhani H, Sharif MA.** *Dendritic Neighborhood State Controls Synaptic Plasticity Outcomes: A Computational Model of Local Gating Mechanisms.* Journal of Computational Neuroscience (under revision).

The model shows how the state of neighboring synapses on a dendritic branch decides whether the **same stimulus** produces **LTP, LTD or no change** at a target synapse. It does this through two branch-level mechanisms:

1. **Voltage-mediated cooperativity.** Co-active neighbors depolarize the shared branch. The depolarization reaches the target spine head through its neck and relieves the Mg²⁺ block of its NMDA receptors, so more calcium enters the target spine.
2. **A shared resource pool.** LTP draws resource from a branch-level pool into the synaptic weights, and LTD returns it. Potentiating synapses therefore compete, and the growth of total branch weight is limited.

<p align="center">
  <img src="figures_main/fig1_schematic.png" width="650" alt="Model schematic">
</p>

---

## Model

A branch segment carries `N = 21` synapses: 1 target and 20 neighbors, of which `K` are co-active with the target. Each synapse sits on a spine head, which is coupled to a single dendritic compartment through a spine-neck conductance.

| Component | Equation |
|---|---|
| Branch voltage | `C_d dV_d/dt = g_L (E_L − V_d) + Σ_i g_neck (V_s,i − V_d)` |
| Spine head (quasi-steady state) | `0 = g_neck (V_d − V_s,i) + g_A,i (E_AMPA − V_s,i) + g_N,i B(V_s,i) (E_NMDA − V_s,i)` |
| Mg²⁺ block (Jahr & Stevens, 1990) | `B(V) = 1 / (1 + [Mg]/3.57 · exp(−0.062 V))` |
| AMPA / NMDA gating | `ds_A/dt = −s_A/τ_A + I(1 − s_A)/τ_on`, `ds_N/dt = −s_N/τ_N,decay + I(1 − s_N)/τ_N,rise` |
| Spine calcium | `dCa_i/dt = (Ca_rest − Ca_i)/τ_Ca + α_Ca g_N,i B(V_s,i) (E_Ca − V_s,i)/(E_Ca − E_L)` |
| Plasticity | `dw_i/dt = η_LTP [Ca_i − θ_LTP]₊ (R/R₀)(1 − w_i/w_max) − η_LTD [Ca_i − θ_LTD]₊ w_i` |
| Shared pool | `dR/dt = −Σ_i dw_i/dt + (R₀ − R)/τ_R` |
| Expression | `dw_E,i/dt = (w_i − w_E,i)/τ_E`, with conductances `g_A,i = g_AMPA w_E,i s_A,i`, `g_N,i = g_NMDA w_E,i s_N,i` |

The pool equation gives `d(R + Σw)/dt = (R₀ − R)/τ_R`, so pool plus weights is approximately conserved on time scales shorter than `τ_R`.

Conductances are calibrated so that a single input produces a **16.6 mV spine-head EPSP** and a **1.44 mV branch EPSP**. All parameters, with units and references, are in [`params_default.m`](params_default.m).

## Main results

| | |
|---|---|
| **Neighborhood selects the sign of plasticity** — the same burst gives no change alone (Δw = −0.001), LTD with 6 co-active neighbors (−0.048) and LTP with 12 (+0.210) | <img src="figures_main/fig2_neighbourhood_selects_sign.png" width="420"> |
| **Phase diagram** — no-change, LTD and LTP regimes as a function of target strength and number of co-active neighbors | <img src="figures_main/fig3_phase_diagram.png" width="420"> |
| **LTD → facilitation → competition** as the co-active neighborhood grows | <img src="figures_main/fig4_ltd_facilitation_competition.png" width="420"> |

---

## Requirements

- MATLAB R2020b or later, **or** GNU Octave 8 or later
- No toolboxes required

## Quick start

```matlab
p = params_default();

% Target alone, + 6 and + 12 co-active neighbours (all strengths 0.5), simulated in parallel
p.stim_strengths = make_S(p.N_syn, 0.5, [0 6 12], 0.5);

[t, rec] = run_simulation(p, @stim_protocol, struct('record', true, 'verbose', true));

rec.dw(:, 1)      % target weight change: approx. [-0.001; -0.048; +0.210]
plot(t, rec.Ca)   % target spine calcium for the three conditions
```

Each row of `p.stim_strengths` is one condition and each column one synapse; column 1 is the target. All rows are integrated in parallel (vectorized).

### Useful options

| Field | Meaning |
|---|---|
| `p.stim_strengths` | `1×N` or `K×N` dimensionless drive per synapse (0 = inactive) |
| `p.stim_times`, `p.stim_duration` | Presynaptic pulse times (ms) and pulse width (ms) |
| `p.neighbor_delay` | Delay of neighbors relative to the target (ms) |
| `p.w_init`, `p.wE_init`, `p.R_init` | Initial weights, expressed weights and pool content |
| `p.use_Mg_block = false` | Ablation: voltage-independent block `B = p.B_fixed` |
| `p.use_resource = false` | Ablation: unlimited pool (`R ≡ R₀`) |
| `p.voltage_coupling = false` | Ablation: neighbor spines do not load the branch |
| `p.dt`, `p.T_total` | Euler time step and simulation length (ms) |

## Reproducing the paper

```matlab
generate_all_figures
```

This regenerates every main and supplementary figure (`figures_main/`, `figures_supp/`) and runs the time-step convergence check. Every number quoted in the paper is written to `results_log.txt`, and the underlying data to `results_main.mat`, `results_supp.mat` and `results_convergence.mat`. Run time is about 15–25 minutes.

| Script | Output |
|---|---|
| `generate_main_figures.m` | Figures 1–7 |
| `generate_supp_figures.m` | Figures S1–S7 |
| `convergence_check.m` | Supplementary Table S1 (Δw for dt = 0.1, 0.05, 0.025, 0.0125 ms) |

| Figure | Content |
|---|---|
| 1 | Model schematic |
| 2 | The neighborhood selects no change, LTD or LTP |
| 3 | Phase diagram: target strength × number of co-active neighbors |
| 4 | LTD, facilitation and competition vs. neighborhood size and strength |
| 5 | 2×2 dissection: {voltage-dependent Mg²⁺ block} × {shared pool} |
| 6 | LTP and LTD on one branch; resource-limited growth of total weight |
| 7 | Frequency dependence, weight dependence (BTSP-like) and branch history |
| S1 | Electrical calibration (spine and branch EPSPs, input integration, Mg²⁺ block) |
| S2 | Weight stabilization |
| S3 | Timing window |
| S4 | History dependence across repeated epochs, with pool vs. weight control |
| S5 | Parameter robustness |
| S6 | Protocol dependence |
| S7 | Operating regime: branch impedance, AMPA block, hyperpolarization |

## Repository structure

```
├── params_default.m          Default parameters (units, references)
├── model_odes.m              Right-hand side of the model (vectorized: conditions × synapses)
├── spine_voltage.m           Quasi-steady-state spine-head voltages (Newton's method)
├── mg_block.m                Jahr–Stevens Mg²⁺ block (or fixed block for ablations)
├── stim_protocol.m           Presynaptic drive
├── run_simulation.m          Forward-Euler integration, summary statistics and traces
├── make_S.m                  Builds stimulation rows: target + K co-active neighbours
├── generate_all_figures.m    Reproduces all figures and logs all quoted values
├── generate_main_figures.m   Figures 1–7
├── generate_supp_figures.m   Figures S1–S7
├── convergence_check.m       Supplementary Table S1
├── figure_defaults.m, panel_label.m, ref_line.m, draw_box.m, two_slope_map.m,
│   set_cbar_ticks.m, parula_like.m, corr_simple.m, ifelse_str.m, save_figure.m
│                             Plotting helpers (portable between MATLAB and Octave)
├── figures_main/, figures_supp/
├── results_log.txt           All values quoted in the paper
└── LICENSE
```

## Version history

**v2.0 (revision).** Changes made in response to peer review:
- Spine compartments with a 500 MΩ neck resistance; calibrated EPSP amplitudes (v1.0 produced a ~29 mV branch EPSP for a single input)
- Jahr–Stevens Mg²⁺ block
- Shared pool reformulated: LTP moves resource from R into w, LTD returns it; LTD ∝ w, LTP soft-bounded
- Depression active for all Ca > θ_LTD (Graupner–Brunel-type rule), giving a robust LTD regime; no hard resource threshold
- Slow expression of weight changes in the conductances (τ_E)
- Vectorized simulation of many conditions; MATLAB and Octave compatible
- Branch-level competition, frequency dependence, weight dependence, history controls and a convergence check added

**v1.0.** Original submission: two synapses in a single shared compartment; resource consumed by calcium.

## Citation

If you use this code, please cite:

```bibtex
@article{Borjkhani_DendriticNeighborhood,
  author  = {Borjkhani, Mehdi and Borjkhani, Hadi and Sharif, Morteza A.},
  title   = {Dendritic Neighborhood State Controls Synaptic Plasticity Outcomes: A Computational Model of Local Gating Mechanisms},
  journal = {Journal of Computational Neuroscience},
  note    = {Under revision}
}
```

## License

MIT License — see [LICENSE](LICENSE).

## Contact

**Mehdi Borjkhani**
International Centre for Translational Eye Research (ICTER)
Institute of Physical Chemistry, Polish Academy of Sciences, Warsaw, Poland
mborjkhani@ichf.edu.pl
