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
		RefineFunction = MaxGradient(Variable = "DopingConcentration",Value = 1)
		RefineFunction = MaxLenInt(Interface("Silicon","Contact"), Value=0.001, factor=2)
	}
}

Placements {
	Constant "ConstantProfilePlacement_nplus" {
		Reference = "ConstantProfileDefinition_nplus"
		EvaluateWindow {
			Element = region ["region_nplus"]
		}
	}
	Constant "ConstantProfilePlacement_pplus" {
		Reference = "ConstantProfileDefinition_pplus"
		EvaluateWindow {
			Element = Rectangle [(0 0) (5 1)]
		}
	}
	Refinement "RefinementPlacement_np_mesh" {
		Reference = "RefinementDefinition_np_mesh"
		RefineWindow = Rectangle [(-0.1822 1.183) (10.2553 -0.2318)]
	}
}

