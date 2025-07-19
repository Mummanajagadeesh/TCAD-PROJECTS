Title ""

Controls {
}

IOControls {
	outputFile = "sdemodel_nmos_mesh"
	EnableSections
}

Definitions {
	Constant "ConstantProfileDefinition_sub" {
		Species = "BoronActiveConcentration"
		Value = 1e+16
	}
	Constant "ConstantProfileDefinition_ns" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+19
	}
	Constant "ConstantProfileDefinition_nd" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+19
	}
	Refinement "RefinementDefinition_mesh" {
		MaxElementSize = ( 0.5 0.5 )
		MinElementSize = ( 0.001 0.001 )
		RefineFunction = MaxGradient(Variable = "DopingConcentration",Value = 1)
		RefineFunction = MaxLenInt(Interface("Silicon","SiO2"), Value=0.001, factor=2, DoubleSide)
		RefineFunction = MaxLenInt(Interface("Silicon","Contact"), Value=0.001, factor=2, DoubleSide)
	}
}

Placements {
	Constant "ConstantProfilePlacement_sub" {
		Reference = "ConstantProfileDefinition_sub"
		EvaluateWindow {
			Element = region ["region_substrate"]
		}
	}
	Constant "ConstantProfilePlacement_ns" {
		Reference = "ConstantProfileDefinition_ns"
		EvaluateWindow {
			Element = Rectangle [(0 10) (5 9.7)]
		}
	}
	Constant "ConstantProfilePlacement_nd" {
		Reference = "ConstantProfileDefinition_nd"
		EvaluateWindow {
			Element = Rectangle [(10 10) (15 9.7)]
		}
	}
	Refinement "RefinementPlacement_mesh" {
		Reference = "RefinementDefinition_mesh"
		RefineWindow = Rectangle [(-1.5346 11.8995) (16.5315 -1.778)]
	}
}

