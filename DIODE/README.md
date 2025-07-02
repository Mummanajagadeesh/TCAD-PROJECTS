# **TCAD – PN Junction Diode Setup and Simulation**

This document outlines the complete process to model, mesh, and simulate a **planar silicon PN junction diode** using Synopsys Sentaurus TCAD tools. The explanation assumes usage of the GUI for structure building, followed by command-line simulation execution using a `.cmd` script.

---

### **Structure Drawing (Geometry Setup)**

* Open the **Draw** module.

* Disable **Auto Region Naming**. This gives you control over how regions are named instead of letting the tool auto-generate labels.

* Enable **Exact Coordinates**. This ensures that when you enter coordinate values, the tool will snap exactly to those points rather than approximate.

* Switch to **XY View** using the lens icon, which simplifies drawing in 2D by locking into the top-down view.

* Select the **Rectangle Tool**.

* Enter:

  * `x1 = 0`, `y1 = 0`
  * `x2 = 10`, `y2 = 1`

  This creates a rectangular silicon body measuring 10μm wide and 1μm tall. The layout will later be split into p-type and n-type regions to define the PN junction.

* Use the **Fit to View** option (lens icon) to see the entire drawn structure.

---

### **Doping Profile Assignment**

* Navigate to **Device > Constant Profile Placement**.

* Select the **Region** option and highlight only the **left half** of the device:

  * Use coordinates `(0, 0)` to `(5, 1)`.

* For this left half:

  * Choose **BoronActiveConcentration**.
  * Set concentration to `1e+17 cm⁻³`.

  This defines a highly doped **p-type** region using boron as the dopant.

* Repeat the doping process for the **right half**:

  * Use coordinates `(5, 0)` to `(10, 1)`.

* For this right half:

  * Choose **PhosphorusActiveConcentration**.
  * Set concentration to `1e+16 cm⁻³`.

  This defines a moderately doped **n-type** region, creating the PN junction along the shared interface at `x = 5μm`.

* Save the structure at this point before proceeding to meshing.

---

### **Contact Definition and Assignment**

* Go to **Contact > Contact Sets**.

* Define two contacts:

  * Name: `Anode` with code `100` (typically red)
  * Name: `Cathode` with code `001` (typically blue)

* Click **Set** after naming each one to register them.

* Activate the **Cursor Tool** from the left toolbar to enter selection mode.

* Change the **Select Body** dropdown to **Select Edge**.

* Click on the **top-left edge** of the rectangle (corresponding to the p-region), then select `Anode` from the contact dropdown and assign it.

* Click on the **top-right edge** of the rectangle (corresponding to the n-region), assign it as `Cathode`.

This setup connects the p and n regions to external terminals. Current will flow vertically through the junction when a forward or reverse bias is applied.

---

### **Meshing the Structure**

#### Left Region Doping Placement

* Before global meshing, create a **Refinement/Evaluation Window** over only the left half of the structure:

  * Draw a rectangle from `(0, 0)` to `(5, 1)`.

* Assign the boron doping here as described in the doping step. This ensures tight coupling between region-based geometry and doping definitions before full refinement.

---

#### Defining the Meshing Area

* Go to **Mesh > Define Rel/Eval Window > Rectangle**.
* Draw a rectangle large enough to completely enclose the entire silicon structure (from left to right).
  The exact coordinates don’t matter, as long as the device is fully enclosed.

This step defines the full refinement boundary for meshing rules.

---

#### Mesh Refinement Placement

* Go to **Mesh > Refinement Placement** and choose **Mesh in Rel/Eval Window**.

* Set mesh resolution:

  * `Min element size x`: `0.001` (nm)
  * `Max element size x`: `0.5` (nm)
  * `Min and Max element size y`: `0.1` (nm)

This provides fine resolution in the horizontal (x) direction, essential for resolving the abrupt doping transition across the PN junction.

* Click **More Options >>** to open additional mesh parameters.

* Enable **Interface Length** refinement:

  * Select `Silicon` and `Contact` as interface materials.
  * Set **Length** to `0.001` (same as minimum x mesh).
  * Set **Factor** to `2`.

  This creates dense mesh near the material interfaces and allows gradual spacing away from the junction or contact. A factor of 2 means each mesh element further from the interface will be twice the size of the previous, maintaining resolution where physics change sharply.

* Enable **Gradient-based refinement** as well:

  * Choose `BoronActiveConcentration` as the variable.
  * Set **Value** to `1`.

  This adds denser mesh wherever doping gradients are large, such as near the PN junction, enhancing accuracy of field and carrier profiles.

* Click **Add and Place** to finalize the refinement configuration.

---

#### Building the Mesh

* Go to **Mesh > Build Mesh**.
* The generated mesh will open automatically in **SVisual**, allowing for inspection and validation.

---

### **Simulation Execution**

#### Using Command Line Tools

To simulate the diode and generate IV characteristics, use the following commands:

```bash
sde                        # Opens Structure Editor (if needed)
svisual                    # View the device and mesh
sdevice filename.cmd       # Run the simulation
```

* Ensure that your `.cmd` file includes correct physics models, initial conditions, and sweep parameters.
* Once the simulation finishes, open **SVisual** to visualize electric field, current flow, potential, and IV curves.

---

### **Pre-Simulation Structure and Mesh Setup File**

This section captures the doping and mesh refinement setup just before running the simulation. It reflects both the physical layout (split doping regions) and the fine-tuned meshing strategy using interface and doping-based refinement. The mesh is expected to be finest near the PN junction and at contacts, and coarser in the bulk.

Use this file as a checkpoint or for regeneration of the geometry and mesh in future sessions.

```txt
Title ""

Controls {
}

IOControls {
    outputFile = "sdemodel_np_mesh"
    EnableSections
}

Definitions {
    Constant "ConstantProfileDefinition_nplus" {
        Species = "PhosphorusActiveConcentration"
        Value = 1e+16
    }
    Constant "ConstantProfileDefinition_pplus" {
        Species = "BoronActiveConcentration"
        Value = 1e+17
    }
    Refinement "RefinementDefinition_np_mesh" {
        MaxElementSize = ( 0.5 0.1 )
        MinElementSize = ( 0.001 0.1 )
        RefineFunction = MaxGradient(Variable = "BoronActiveConcentration", Value = 1)
        RefineFunction = MaxLenInt(Interface("Silicon", "Contact"), Value = 0.001, factor = 2)
    }
}

Structure {
    Region "region_pplus" {
        Material = "Silicon"
        Geometry = Rectangle [(0 0) (5 1)]
    }
    Region "region_nplus" {
        Material = "Silicon"
        Geometry = Rectangle [(5 0) (10 1)]
    }

    Contact "Anode" {
        Geometry = Line [(0 1) (5 1)]
    }
    Contact "Cathode" {
        Geometry = Line [(10 1) (5 1)]
    }

    Interface {
        Regions = ("region_pplus", "region_nplus")
    }
}

Placements {
    Constant "ConstantProfilePlacement_pplus" {
        Reference = "ConstantProfileDefinition_pplus"
        EvaluateWindow {
            Element = region ["region_pplus"]
        }
    }

    Constant "ConstantProfilePlacement_nplus" {
        Reference = "ConstantProfileDefinition_nplus"
        EvaluateWindow {
            Element = region ["region_nplus"]
        }
    }

    Refinement "RefinementPlacement_np_mesh" {
        Reference = "RefinementDefinition_np_mesh"
        RefineWindow = Rectangle [(-0.231 1.3294) (10.3285 -0.5001)]
    }
}
```

---

### **Tips for Extension**

* Use finer mesh and denser gradient refinement if high doping contrast or short depletion widths are involved.
* Consider enabling temperature effects or transient analysis for reverse recovery simulations.
* Use IV plots to analyze forward conduction, reverse breakdown, and ideality factor.

---

## **Script**

### **File Block**

```txt
File {
    Grid = "sdemodel_np_mesh_msh.tdr" 
    Current = "@plot"
    Plot = "@drdata"
    Output = "@log"
}
```

This block specifies the file I/O settings for the simulation:

* `Grid` is the mesh/structure file (`.tdr`) — in this case, a PN junction mesh created earlier.
* `Current` refers to the file where **current-voltage (IV)** data will be stored.
* `Plot` contains full simulation output for later visualization (e.g., band diagrams, fields, carrier data).
* `Output` captures all console/log output including errors, convergence, warnings — useful for debugging.

The use of `@` variables (like `@plot`, `@drdata`, `@log`) lets Sentaurus auto-name or internally manage file names based on context or prefixes defined later in the script.

---

### **Electrode Block**

```txt
Electrode {
    { Name = "Anode" Voltage = 0.0 }
    { Name = "Cathode" Voltage = 0.0 }
}
```

Initial electrical setup:

* Both contacts (`Anode` and `Cathode`) are set to `0V` initially.
* This is a **starting point** for the sweep. Bias will be applied later in the `Solve` block.

---

### **Physics Block**

```txt
Physics {
    Mobility (
        DopingDependence
        # HighFieldSaturation(GradQuasiFermi)
    )
    Recombination (SRH(DopingDependence))
    EffectiveIntrinsicDensity (BandGapNarrowing(oldSlotboom))
    Fermi
}
```

This sets up the physics models to reflect real semiconductor behavior:

* `Mobility(DopingDependence)` — carrier mobility depends on local doping levels (common in heavily doped regions).

  * The line `HighFieldSaturation(...)` is commented out; it would model velocity saturation at high fields.
* `Recombination (SRH(DopingDependence))` — classic Shockley–Read–Hall recombination, with rate affected by doping concentration.
* `EffectiveIntrinsicDensity` with `BandGapNarrowing(oldSlotboom)` accounts for narrowing of the bandgap due to heavy doping (important in junctions).
* `Fermi` — full Fermi–Dirac statistics instead of Boltzmann approximation, for better accuracy at high doping.

---

### **Plot Block**

```txt
Plot {
    eCurrent Current AvalancheGeneration ConductionCurrent/Vector 
    eAlphaAvalanche hAlphaAvalanche AugerRecombination
    EquilibriumPotential IntrinsicDensity
    EffectiveIntrinsicDensity Temperature ElectricField Potential Doping
}
```

This block tells the simulator what **physical quantities** to save for post-processing:

* Includes current components, recombination data, energy levels, temperature, doping, and electric field.
* `ConductionCurrent/Vector` stores direction + magnitude.
* These results can be viewed in **SVisual** to analyze junction behavior, depletion width, and forward/reverse conduction dynamics.

---

### **Math Block**

```txt
Math {
    Number_of_Threads = 4
    Iterations = 10
    NotDamped = 20
    RHSMin = 1e-8
    # Extrapolate
    Derivatives
    AvalDerivatives
    ErrRef(Electron) = 1e10
    ErrRef(Hole) = 1e10
    method = pardiso
    transient = BE
    -CheckUndefinedModels
}
```

Defines numerical solver controls:

* `Number_of_Threads = 4` — uses 4 CPU threads to speed up solving.
* `Iterations = 10` — max Newton-Raphson iterations per solve.
* `NotDamped = 20` — tries to accelerate convergence before applying damping.
* `RHSMin = 1e-8` — minimum threshold for residuals to be considered “converged.”
* `Derivatives` and `AvalDerivatives` — automatic Jacobian derivatives (for better nonlinear convergence).
* `ErrRef(...) = 1e10` — these high values reduce sensitivity to local error estimates.
* `method = pardiso` — fast sparse matrix solver.
* `transient = BE` — Backward Euler method (mostly relevant if transient solves are activated).
* `-CheckUndefinedModels` — disables warnings for unused/undefined models.

---

### **Solve Block**

```txt
Solve {
    Coupled (iterations = 100 LineSearchDamping = 1e-4) { Poisson }
    Coupled (iterations = 100) { Poisson Electron Hole }

    NewCurrentFile = "2"

    Quasistationary (
        InitialStep = 1e-3
        MinStep = 1e-7
        MaxStep = 0.01
        Increment = 1.4
        Goal { Name = "Anode" Voltage = 2 }
    )
    {
        Coupled { Poisson Electron Hole }
        CurrentPlot (Time = (range = (0 1) intervals = 50))
        Plot (FilePrefix = "n@node@" Time = (range = (0 1) Intervals = 8) NoOverwrite)
    }
}
```

This controls the **solution strategy and bias sweep**:

#### Initial Solves

* `Coupled (...) { Poisson }` solves for electrostatic potential only — gives an initial guess.
* `Coupled { Poisson Electron Hole }` then enables full carrier transport model — the actual semiconductor simulation begins here.

#### Bias Sweep

* `NewCurrentFile = "2"` starts a new file to log current results.

Then the **Quasi-Stationary Sweep** is run:

* Voltage is swept from 0V → 2V on the `Anode` (simulating **forward bias**).
* `InitialStep = 1e-3`, `MinStep = 1e-7`, `MaxStep = 0.01`, and `Increment = 1.4` — these control how step size adapts:

  * If convergence is fast, steps grow 1.4× each time.
  * If convergence is poor, step size shrinks, but not below `1e-7`.

#### Solve Block Inside Sweep

```txt
Coupled { Poisson Electron Hole }
```

Solves the full drift-diffusion model at each bias point.

#### Plotting and Current Monitoring

```txt
CurrentPlot (Time = (range = (0 1) intervals = 50))
Plot (FilePrefix = "n@node@" Time = (range = (0 1) Intervals = 8) NoOverwrite)
```

* `CurrentPlot` tracks the current over the bias sweep — useful for IV curve generation.
* `Plot` periodically saves detailed simulation snapshots (8 total over the 0–1 range). `n@node@` allows dynamic filename expansion, and `NoOverwrite` avoids overwriting existing data.

