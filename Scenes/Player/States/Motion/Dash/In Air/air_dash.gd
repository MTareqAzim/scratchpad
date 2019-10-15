extends "../dash.gd"

var _prev_gravity: int

func enter():
	_prev_gravity = owner.GRAVITY
	owner.GRAVITY = 0
	.enter()


func update(delta):
	_fix_z_velocity(0)
	.update(delta)


func exit():
	owner.GRAVITY = _prev_gravity
	.exit()
