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

