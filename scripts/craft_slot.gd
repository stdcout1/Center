extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).expand = true
	pass # Replace with function body.


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if GlobalTileMap.items[name] in GlobalTileMap.inv:
				GlobalTileMap.inv[name][0] += 1
			else:
				GlobalTileMap.inv[name] = GlobalTileMap.items[name]
				GlobalTileMap.inv[name][0] += 1
			for ing in GlobalTileMap.recipies[name].keys():
				var val = GlobalTileMap.recipies[name][ing]
				GlobalTileMap.inv[ing][0] -= val
			GlobalTileMap.update_inv = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
