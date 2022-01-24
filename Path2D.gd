extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(curve.get_point_count())
	print(curve.get_point_position(0))
	self_modulate.r8 = 250
	print(curve.get_closest_point(get_parent().get_child(0).position))
	get_parent().get_child(2).position = curve.get_point_position(0)
	pass 


