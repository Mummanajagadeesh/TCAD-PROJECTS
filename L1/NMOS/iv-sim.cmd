File {
    Grid="sdemodel_nmos_mesh_msh.tdr"
    Current="@IV"
    Plot="@@es_tdr"
    Output="@@log@@"
}

Electrode {
    { Name="Body"   Voltage=0.0 }
    { Name="Source" Voltage=0.0 }
    { Name="Drain"  Voltage=0.0 }
    { Name="Gate"   Voltage=0.0 workfunction=4.2 }
}

Physics {
    EffectiveIntrinsicDensity(OldSlotboom)
    Fermi
    eQuantumPotential
    Mobility(
        DopingDependence
        CarrierCarrierScattering
        HighFieldSaturation(GradQuasiFermi)
        HighFieldSaturation(GradQuasiFermi)
        Enormal
    )

    Recombination(
        SRH(DopingDep)
        Auger
    )
}

Plot {
    eCurrent hCurrent AvalancheGeneration ConductionCurrent
    eAlphaAvalanche hAlphaAvalanche AugerRecombination
    EquilibriumPotential IntrinsicDensity
    EffectiveIntrinsicDensity Temperature ElectricField Potential Doping
    SpaceCharge
    eBarrierTunneling hBarrierTunneling
    conductionbandenergy valancebandenergy
}

Math {
    Number_of_Threads = 4
    Iterations = 10
    NotDamped = 20
    RHSMIN = 1e-8
    #Extrapolate
    Derivatives
    AvalDerivatives
    ErrRef(Electron) = 1e10
    ErrRef(Hole) = 1e10
    method = pardiso
    #ComputeGradQuasiFermiAtContacts= UseQuasiFermi

    transient=BE
    #MobilityAveraging = ElementEdge
    #hMobilityAveraging = ElementEdge

    #BreakCriteria {LatticeTemperature (MaxVal =1400)}
    -CheckUndefinedModels
}

Solve {
    Poisson
    Coupled (iterations=50) {Poisson Electron}
    Coupled (iterations=50) {Poisson Hole}
    Coupled (iterations=50) {Poisson Electron Hole}

    Plot (FilePrefix="nmos_initial")

    Quasistationary (
        InitialStep=0.1 Minstep=1e-5 MaxStep=0.1 Increment=1.3
        Goal {Name="Gate" Voltage=2.5}
    )
    {
        Coupled {Poisson Electron Hole}
    }

    Plot (FilePrefix="nmos")
    NewCurrentFile="nmos_IV"

    Quasistationary (
        DoZero
        InitialStep=0.001 Minstep=1e-5 MaxStep=0.1 Increment=1.3
        Goal {Name="Drain" Voltage=5}
    )
    {
        Coupled {Poisson Electron Hole}
    }
}

