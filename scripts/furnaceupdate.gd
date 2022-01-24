extends TextureRect



var orig_name


func _ready():
	orig_name = name#save the origianl name of the panel
	pass 


# Called every frame.
func _process(delta):
	if name != orig_name:#if the name of the panel has changed
		if get_child(1).text == "0":#check if there are zero of the items left
			get_child(0).texture = null#if so then remove its texture from the panel
			get_child(1).text = ""#and erase its value
			GlobalTileMap.inv.erase(name)#and erase it from the inventory
			GlobalTileMap.furnace.erase(name)#and erase it from furnace
			GlobalTileMap.equiped = ""#and make equipped equals to nothing
			name = orig_name#and reset the name back to the original
		elif get_child(1).text != "0" and get_child(1).text != "":
			#else if the value is not zero then make the value equal to the amount in the inventory
			get_child(1).text = str(GlobalTileMap.inv[name][0])
