extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
#with each frame this checks the furnace panels and determines whether a recipie meets all conditions
#which are the amount of materials needed, and the amount of the materials needed
	if visible:
		for y in GlobalTileMap.furnace_recipies:
			var count1 = 0
			var count2 = 0
			var burnable = false
			if GlobalTileMap.furnace.size() == GlobalTileMap.furnace_recipies[y].size():
				for x in GlobalTileMap.furnace_recipies[y]:
					if x in GlobalTileMap.furnace:
						if GlobalTileMap.inv[x][0] >= GlobalTileMap.furnace_recipies[y][x]:
							count1 += 1
						if count1 == GlobalTileMap.furnace_recipies[y].size():
							burnable = true
			if burnable:
				texture = load(GlobalTileMap.items[y][1])
				name = y
				break


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:#this checks if the player has clicked on the texture
			if texture != null:#if there is a texture, which means something is burnable
				for x in GlobalTileMap.items:#then either add it to the inventory if it is not there already
					#or add one to its amount if its already in the inventory
					if x == name:
						texture = null
						name = ""
						if x in GlobalTileMap.inv:
							GlobalTileMap.inv[x][0] += 1
							for y in GlobalTileMap.furnace_recipies[x]:
								GlobalTileMap.inv[y][0] -= GlobalTileMap.furnace_recipies[x][y]
						else:
							for y in GlobalTileMap.furnace_recipies[x]:
								GlobalTileMap.inv[y][0] -= GlobalTileMap.furnace_recipies[x][y]
							GlobalTileMap.inv[x] = GlobalTileMap.items[x]
							GlobalTileMap.inv[x][0] += 1
						GlobalTileMap.update_inv = true 
						print (GlobalTileMap.inv)
