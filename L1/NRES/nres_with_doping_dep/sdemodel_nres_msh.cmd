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
	Refinement "RefinementDefinition_1" {
		MaxElementSize = ( 0.5 0.1 )
		MinElementSize = ( 0.01 0.1 )
		RefineFunction = MaxLenInt(Interface("Silicon","All"), Value=0.01, factor=2)
	}
}

Placements {
	Constant "ConstantProfilePlacement_nres" {
		Reference = "ConstantProfileDefinition_nres"
		EvaluateWindow {
			Element = region ["region_nres"]
		}
	}
	Refinement "RefinementPlacement_nres" {
		Reference = "RefinementDefinition_1"
		RefineWindow = Rectangle [(-0.9629 1.2198) (10.7946 -0.523)]
	}
}

