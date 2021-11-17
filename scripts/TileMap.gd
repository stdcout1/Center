extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const gen_list = [
	["1"], #rare
	["0"], #common
	["2"] #world
]
var world_vals = []


var equiped = "stone"

var inv = {}
var items = {
	"stone" : [0,"res://items/Sheet472.png"],  # -> 1: amount, 2:texture, 
	"coal" : [0,"res://items/Sheet496.png"],
	"gold" : [0,"res://items/Sheet444.png"],
	"redstone" : [0,"res://item/Sprite-0003.png"],
	"stone_sword" : [0,"res://items/Sheet6.png",10,100 ,"item"] # -> 1: amount, 2:texture, 3: damage, 4: dur -1: type
}

# Called when the node enters the scene tree for the first time.
func _ready():
	gen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gen():
	world_vals = []
	var x = 0
	for i in gen_list:
		x+=1
		for p in i:
			for _e in range(pow(5,x)):
				world_vals.append(p)
