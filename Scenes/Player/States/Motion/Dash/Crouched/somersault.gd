tool
extends "../dash.gd"

export (int) var CROUCH_HEIGHT := 50

var _prev_height: int

func enter():
	owner.set_height(CROUCH_HEIGHT)
	.enter()

