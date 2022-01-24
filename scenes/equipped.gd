extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	look_at(get_global_mouse_position())#changes its rotationg so its looking at the mouse
	if rotation_degrees > 90 or rotation_degrees < -90:#flips the texture depending on the angle of rotation
		flip_v = true
	elif rotation_degrees < 90 or rotation_degrees > -90:
		flip_v = false
	if rotation_degrees <= -270 or rotation_degrees >= 270:
		flip_v = false
	if rotation_degrees <= -360 or rotation_degrees >= 360:
		rotation_degrees = 0
