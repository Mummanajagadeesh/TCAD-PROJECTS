Title ""

Controls {
}

IOControls {
	outputFile = "sdemodel_nres"
	EnableSections
}

Definitions {
	Constant "ConstantProfileDefinition_nres" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+16
	}
	Refinement "RefinementDefinition_nres_mesh" {
		MaxElementSize = ( 0.5 0.1 )
		MinElementSize = ( 0.01 0.1 )
		RefineFunction = MaxLenInt(Interface("Silicon","Contact"), Value=0.01, factor=2)
	}
}

Placements {
	Constant "ConstantProfilePlacement_nres" {
		Reference = "ConstantProfileDefinition_nres"
		EvaluateWindow {
			Element = region ["region_nres"]
		}
	}
	Refinement "RefinementPlacement_nres_mesh" {
		Reference = "RefinementDefinition_nres_mesh"
		RefineWindow = Rectangle [(-0.4537 1.3965) (10.4715 -0.4085)]
	}
}

