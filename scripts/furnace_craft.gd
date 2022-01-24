extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	return
	if visible:
		for y in GlobalTileMap.furnace_recipies:
			var disturbance = false
			var count1 = 0
			var count2 = 0
			if GlobalTileMap.furnace.size() == GlobalTileMap.furnace_recipies[y].size():
				for x in GlobalTileMap.furnace_recipies[y]:
					if x in GlobalTileMap.furnace:
						if GlobalTileMap.inv[x][0] >= GlobalTileMap.furnace_recipies[y][x]:
							count1 += 1
			if count1 == GlobalTileMap.furnace_recipies[y].size():
				get_child(0).texture = load(GlobalTileMap.items[y][1])
				get_child(0).name = y
				break
			
				
