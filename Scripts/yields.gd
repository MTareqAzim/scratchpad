extends Node

var prevObj = null
var yields = []
var timesUp = false


func _ready():
	$Timer.start()
	yields.append(bustUpTheBricks())

func bustUpTheBricks():
	var c = (randi() % 20) + 1
	for i in range(c):
		var timer : Timer = Timer.instance()
		timer.start(0.2)
		yield(timer, "timeout")
		timer.stop()
		timer.free()
		if timesUp:
			break
		print(i, " out of ", c)


func _on_Timer_timeout():
	timesUp = true
	
	for _yield in yields:
		if _yield:
			_yield.resume()
	
	queue_free()
