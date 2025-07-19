# TCAD-PROJECTS

This repository contains simulation files, documentation, and results for semiconductor devices modeled using TCAD tools

> **Technology Computer-Aided Design (TCAD)** involves using physics-based simulations to design, analyze, and optimize semiconductor devices and fabrication processes. Tools like Synopsys TCAD enable accurate modeling of doping, electric fields, carrier transport, and device behavior, making them essential for modern VLSI and CMOS technology development


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

**SProcess is not used in L2; structures are manually defined in SDE without process step modeling.**


## Tools

- **SPROCESS** – simulating semiconductor fabrication steps like oxidation, implantation, and diffusion  
- **SDE (Sentaurus Device Editor)** – used as an alternative to SPROCESS for manual device structure and doping setup  
- **SDEVICE** – simulating electrical behavior and solving semiconductor equations  
- **SVISUAL** – visualizing results like potential, doping, and carrier densities  
- **SWB (Sentaurus Workbench)** – managing and running TCAD simulation projects