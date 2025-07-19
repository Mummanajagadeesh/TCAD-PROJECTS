Title ""

Controls {
}

IOControls {
	outputFile = "./sdemodel_nres"
	EnableSections
}

Definitions {
	Constant "ConstantProfileDefinition_nres" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+16
	}
	Refinement "RefinementDefinition_nres" {
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
	Refinement "RefinementPlacement_nres" {
		Reference = "RefinementDefinition_nres"
		RefineWindow = Rectangle [(-0.3141 1.4991) (10.5458 -0.4991)]
	}
}

