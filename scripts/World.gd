extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const RES_X = 1024
const RES_Y = 512
const block_size = 32
const mine_range = 2
	
onready var Map = $TileMap
onready var Player = $player
onready var camera = $player/Camera2D
onready var sprite = $player/Sprite

var done = NAN

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Player.position.y)
	gen_m()
	pass # Replace with function body.
func gen_t(line):
	addtogen([0,30], '3', 2)
	addtogen([30,INF], '3', 0)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0,int(RES_X/block_size)):
		var number = rng.randi_range(0,len(GlobalTileMap.world_vals)-1)
		Map.set_cell(i,line,int(GlobalTileMap.world_vals[number]))
func gen_m():
	done = int(block_size/2)
	for i in range(0,int(RES_Y/block_size)):
		gen_t(i)
	var mid = Vector2(int(RES_X/2),int(RES_Y/2))
	Player.position = mid
	
	print(mid)
	#Map.set_cellv(Map.world_to_map(mid),3)
	#clear landing area
	Map.set_cell(int(RES_X/(block_size*2)), int(RES_Y/(block_size*2)),-1)
	#Map.set_cell(int(RES_X/(block_size*2))+1, int(RES_Y/(block_size*2))+1,-1)
	Map.set_cell(int(RES_X/(block_size*2))+1, int(RES_Y/(block_size*2)),-1)
	Map.set_cell(int(RES_X/(block_size*2))+1, int(RES_Y/(block_size*2))-1,-1)
	#Map.set_cell(int(RES_X/(block_size*2))-1, int(RES_Y/(block_size*2))+1,-1)
	Map.set_cell(int(RES_X/(block_size*2))-1, int(RES_Y/(block_size*2)),-1)
	Map.set_cell(int(RES_X/(block_size*2))-1, int(RES_Y/(block_size*2))-1,-1)
	#Map.set_cell(int(RES_X/(block_size*2)), int(RES_Y/(block_size*2))+1,-1)
	Map.set_cell(int(RES_X/(block_size*2)), int(RES_Y/(block_size*2))-1,-1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var do = false
func _process(delta):
	var offset = Map.world_to_map(Player.position) + Vector2(0,int(RES_Y/(block_size*2)))
	#print(offset.y,' ', done)
	if Map.get_cellv(offset) == -1 and done <= offset.y:
		print(offset.y)
		done += 1
		gen_t(offset.y)
	#print(prev_y)
	
	

func addtogen(rag: Array , thing: String, level: int):
	var offset = Map.world_to_map(Player.position) + Vector2(0,int(RES_Y/(block_size*2)))
	if offset.y >= rag[0] and offset.y <= rag[1]:
		if thing in GlobalTileMap.gen_list[level]:
			return
		GlobalTileMap.gen_list[level].append(thing)
	elif thing in GlobalTileMap.gen_list[level]:
		GlobalTileMap.gen_list[level].erase(thing)
	GlobalTileMap.gen()
