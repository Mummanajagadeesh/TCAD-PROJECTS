# TCAD-PROJECTS

This repository contains simulation files, documentation, and results for semiconductor devices modeled using TCAD tools

## L1

Basic device structures:
- N-type resistor (NRES)
- PN junction diode
- NMOS transistor

These are constructed using rectangular blocks and uniform doping, with idealized assumptions to mimic textbook-level structures

## L2

More realistic, industry-style device modeling:
- PN junctions designed using STI, wells, and taps (e.g., 4 STIs, 2 N-taps, 1 P-tap)
- Use of N-wells, P-wells, and layout techniques resembling real CMOS topologies
- Contacts and dopant regions laid out to follow typical CMOS design conventions
- Doping profiles use **analytical/Gaussian functions** to model realistic junction grading and diffusion behavior

The focus is on layout and doping realism — not full fabrication process simulation — to approximate real-world CMOS flows while keeping simulations efficient