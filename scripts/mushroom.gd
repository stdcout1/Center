extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var current_pos = get_parent().get_child(1).world_to_map(position)
	if get_parent().get_child(1).get_cell(current_pos.x, current_pos.y+1) == 5 or get_parent().get_child(1).get_cell(current_pos.x,current_pos.y) != 5:
		queue_free()
