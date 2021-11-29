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
var build_cave = false
var cave_start = 0
var cave_starty = 0
var cave_start2 = 0
var cave_start3 = 0
var cave_start4 = 0
var n = 1
var m = 1
var left_cavex = 0
var right_cavex = 0
var create_cave = []

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_m()
	pass # Replace with function body.
func gen_t(line):
	addtogen([0,30], '3', 3)
	addtogen([30,INF], '3', 2)
	if line == 20:
		addtogen([20,INF], '4', 0)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0,int(RES_X/block_size)):
		var number = rng.randi_range(0,len(GlobalTileMap.world_vals)-1)
		var block = int(GlobalTileMap.world_vals[number])
		Map.set_cell(i,line,int(GlobalTileMap.world_vals[number]))
		if block == 4:
			build_cave = true
			cave_start = i
			cave_starty = line
			cave_start2 = i+1
			cave_start3 = i-1
			cave_start4 = i-2
			GlobalTileMap.gen_list[0].erase('4')
			create_cave = [cave_start,cave_start2,cave_start3,cave_start4]
	if build_cave:
		print ("sup")
		if cave_start4-left_cavex < 0:
			m = -1
		if cave_start2-left_cavex > 31:
			m = 1
		if cave_start2+right_cavex > 31:
			n = -1
		if cave_start4+right_cavex <0:
			n = 1
		left_cavex = left_cavex+m
		right_cavex = right_cavex+n
		for i in create_cave:
			Map.set_cell(i,line,4)
		create_cave = [
			cave_start+right_cavex,cave_start-left_cavex,
			cave_start2+right_cavex,cave_start2-left_cavex,
			cave_start3+right_cavex,cave_start3-left_cavex,
			cave_start4+right_cavex,cave_start4-left_cavex]
		

	if line == cave_starty+200 and cave_starty != 0:
		GlobalTileMap.gen_list[0].append('4')
		build_cave = false
		left_cavex = 0
		right_cavex = 0 
		n = 1
		m = 1
			
			#createcave(i, line)
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
	if Map.get_cellv(offset) == -1 and done <= offset.y:
		done += 1
		gen_t(offset.y)
	
	
func createcave(posx: int , level: int):
	print ("shit", posx, " ", level)
	Map.set_cell(posx-1,level+1,4)
	Map.set_cell(posx+1,level+1,4)
	pass

func addtogen(rag: Array , thing: String, level: int):
	var offset = Map.world_to_map(Player.position) + Vector2(0,int(RES_Y/(block_size*2)))
	if offset.y >= rag[0] and offset.y <= rag[1]:
		if thing in GlobalTileMap.gen_list[level]:
			return
		GlobalTileMap.gen_list[level].append(thing)
	elif thing in GlobalTileMap.gen_list[level]:
		GlobalTileMap.gen_list[level].erase(thing)
	GlobalTileMap.gen()
