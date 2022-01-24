extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#fill up amp and border
	for x in range(20):
		for y in range(20):
			set_cell(x,y,0)
	for x in range(-1,20):
		set_cell(20,x,1)
	for x in range(-1,21):
		set_cell(-1,x,1)
	for x in range(-1,21):
		set_cell(x,20,1)
	for x in range(-1,21):
		set_cell(x,-1,1)
