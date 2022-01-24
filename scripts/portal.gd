extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#fix bomb blopwing up egeds and not subtracting from inv

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			get_parent().get_node("TileMap/CanvasLayer3/MarginContainer2").visible = true
	pass # Replace with function body.
