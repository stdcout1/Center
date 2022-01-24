extends Panel



var selected = false
var reg = StyleBoxTexture.new()
var sel = StyleBoxTexture.new()
var orig_name
var whatever

func _ready():
	orig_name = name #saves the original name of the panel
	sel.texture = load("res://menu resource/itembases.png")# a few preloaded textures for selecting
	reg.texture = load("res://menu resource/itembase.png")
	


#called on every frame
func _process(delta):
	if name != orig_name:#if the name of the panel has changed
		if get_child(1).text == "0":#check if there are zero of the items left
			get_child(0).texture = null#if so then remove its texture from the panel
			get_child(1).text = ""#and erase its value
			GlobalTileMap.inv.erase(name)#and erase it from the inventory
			GlobalTileMap.equiped = ""#and make equipped equals to nothing
			name = orig_name#and reset the name back to the original
		elif get_child(1).text != "0" and get_child(1).text != "":
			#else if the value is not zero then make the value equal to the amount in the inventory
			get_child(1).text = str(GlobalTileMap.inv[name][0])
	if GlobalTileMap.selected == name:
		#if the selected item equals the name of the panel then change the texture of the panel so that it adds a border
		selected = true
		set('custom_styles/panel', sel)
	else:
		#else remove the border
		selected = false
		set('custom_styles/panel', reg)
	

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#if clicked on the panel then make this panel the selected panel and whatever item in it is selected
			if name in GlobalTileMap.inv.keys():
				GlobalTileMap.equiped = name
			GlobalTileMap.selected = name

