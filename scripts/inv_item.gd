extends TextureRect




func _ready():
	pass # Replace with function body.




func _gui_input(event):
	var parent = get_parent().get_parent().get_parent().get_parent().get_parent()
	if parent.visible:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				if GlobalTileMap.inv[GlobalTileMap.equiped][-1] == name:
					texture = load(GlobalTileMap.inv[GlobalTileMap.equiped][1])
					GlobalTileMap.inv[GlobalTileMap.equiped][0] -= 1
