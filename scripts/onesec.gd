extends TextureRect


func _ready():
	var children = get_child(0).get_children()
	for x in children:#saves the original names of the inventory panels
		GlobalTileMap.orig_names.append(x.name)
	GlobalTileMap.inventory(get_child(0).get_children(), GlobalTileMap.armor)#generates the inventory for both the armor and frunace
	GlobalTileMap.inventory(get_child(0).get_children(), GlobalTileMap.furnace)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not visible:
		return
	if GlobalTileMap.update_inv:#if update inventory is true call on the update inventory function in the global tile map
		if name == "Inventory":
			GlobalTileMap.inventory(get_child(0).get_children(), GlobalTileMap.armor)
		else:
			GlobalTileMap.inventory(get_child(0).get_children(), GlobalTileMap.furnace)


func _on_TabContainer_tab_changed(tab):#every time a tab is changed in the inventory 
	GlobalTileMap.update_inv = true
	if tab != 2:#if you left the furnace inventory then clear the furnace off of items
		GlobalTileMap.furnace.clear()
	elif tab == 2: 
		for x in get_parent().get_child(2).get_child(1).get_child(0).get_children():#if entered the furnace tab then reset the inventory panels so that they can be updated
			x.get_child(0).texture = null
			x.get_child(1).text = ""
			x.name = " "


