File {
    Grid = "sdemodel_np_mesh_msh.tdr" 
    Current = "@plot"
    Plot = "@drdata"
    Output = "@log"
}

Electrode {
    { Name = "Anode" Voltage = 0.0 }
    { Name = "Cathode" Voltage = 0.0 }
}

Physics {
    Mobility (
        DopingDependence
        # HighFieldSaturation(GradQuasiFermi)
    )
    Recombination (SRH(DopingDependence))
    EffectiveIntrinsicDensity (BandGapNarrowing(oldSlotboom))
    Fermi
}

Plot {
    eCurrent Current AvalancheGeneration ConductionCurrent/Vector 
    eAlphaAvalanche hAlphaAvalanche AugerRecombination
    EquilibriumPotential IntrinsicDensity
    EffectiveIntrinsicDensity Temperature ElectricField Potential Doping
}

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
    # ComputeGradQuasiFermiAtContacts = UseQuasiFermi
    transient = BE
    # eMobilityAveraging = ElementEdge
    # hMobilityAveraging = ElementEdge
    # BreakCriteria (LatticeTemperature (MaxVal = 1400))
    -CheckUndefinedModels
}

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
        Coupled { Poisson Electron Hole}
        CurrentPlot (Time = (range = (0 1) intervals = 50))
        Plot (FilePrefix = "n@node@" Time = (range = (0 1) Intervals = 8) NoOverwrite)
    }
}


