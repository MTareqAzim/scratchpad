tool
extends ShadowMask
class_name ShadowFlatMask

onready var _ready : bool = true
onready var _collider : CollisionPolygon2D = $CollisionPolygon2D


func get_class() -> String:
	return "ShadowFlatMask"


func is_class(type: String) -> bool:
	return type == "ShadowFlatMask" or .is_class(type)


#Editor functions
func _update_components() -> void:
	if _ready:
		_update_collider()


func _update_collider() -> void:
	_collider.set_polygon(_base.get_polygon())
	_collider.set_position(_base.get_position())


func _on_Base_polygon_changed():
	call_deferred("_update_components")
