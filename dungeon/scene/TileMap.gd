extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MAZE_SIZE = Vector2(31,31)
export var MAZE_POS = Vector2(1, 1)
export var WALL_ID = 7
export var PATH_ID = 6
export var LIMIT_ID = 5
const DIRECTIONS = [
	Vector2.UP*2,
	Vector2.DOWN*2,
	Vector2.RIGHT*2,
	Vector2.LEFT*2,
]
var current_cell = Vector2.ONE
var visited_cells = [current_cell]
var stack = []
var cells = []
var list = []
var wave = 0
onready var enem_r = preload("res://dungeon/scene/sussy.tscn")
onready var enem_m = preload("res://dungeon/scene/sussy_m.tscn")
onready var chest = preload("res://dungeon/scene/chest.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalTileMap.dung != 2:
		return
	var n = 2*Main.waves + 15
	if (n)%2 == 0:
		n+=1
	MAZE_SIZE = Vector2(n,n)
	print(MAZE_SIZE)
	print(Main.waves)
	for i in range(n):
		list.append(PATH_ID)
	list.append(0)
	list.append(1)
	list.append(10)
	
	
	generate_maze()
	
	get_node("../Player/CanvasLayer/RichTextLabel").text = "Welcome. Finish the maze to get a chest. (maze size and loot scales with depth)"
	var spawn_locs_m = get_node("../spawn_m").get_used_cells_by_id(1)
	var spawn_locs_r = get_node("../spawn_m").get_used_cells_by_id(0)
	for i in spawn_locs_m:
		var instance = enem_r.instance()
		var pre_name = instance.name
		get_tree().get_root().add_child(instance)
		instance.position = i*Vector2(64,64)
		var post_name = instance.name
		Main.alive[post_name] = Main.enemies[pre_name].duplicate(true)
	for i in spawn_locs_r:
		
		var instance = enem_r.instance()
		var pre_name = instance.name
		get_tree().get_root().add_child(instance)
		instance.position = i*Vector2(64,64)
		var post_name = instance.name
		Main.alive[post_name] = Main.enemies[pre_name].duplicate(true)

	
	
	var instance = chest.instance()
	instance.name = 'chest'
	instance.z_index = 2
	get_tree().get_root().get_node("Node2D").add_child(instance)
	add_child(instance)
	instance.position = MAZE_POS*Vector2(64,64)+Vector2(32,32)

	
	#1 1 1 1
	#1 1 1 1
	#1 1 1 1

func generate_maze(): #<- recursive backtracking
	#Clear the maze
	
	visited_cells = [current_cell]
	stack.clear()
	# Create walls
	for x in MAZE_SIZE.x:
		for y in MAZE_SIZE.y:
			set_cell(x+MAZE_POS.x, y+MAZE_POS.y, WALL_ID)
	# Create limits
	for x in MAZE_SIZE.x+2:
		set_cell(x+MAZE_POS.x-1, MAZE_POS.y-1, LIMIT_ID)
		set_cell(x+MAZE_POS.x-1, MAZE_POS.y-2, LIMIT_ID)
	for x in MAZE_SIZE.x+2:
		set_cell(x+MAZE_POS.x-1, MAZE_SIZE.y + MAZE_POS.y, LIMIT_ID)
		set_cell(x+MAZE_POS.x-1, MAZE_SIZE.y + MAZE_POS.y+1, LIMIT_ID)
	for y in MAZE_SIZE.y:
		set_cell(MAZE_POS.x-1, MAZE_POS.y + y , LIMIT_ID)
		set_cell(MAZE_POS.x-2, MAZE_POS.y + y , LIMIT_ID)
	for y in MAZE_SIZE.y:
		set_cell(MAZE_SIZE.x + MAZE_POS.x, MAZE_POS.y + y , LIMIT_ID)
		set_cell(MAZE_SIZE.x + MAZE_POS.x+1, MAZE_POS.y + y , LIMIT_ID)
	
	#create cells
	for x in (MAZE_SIZE.x+1)/2:
		for y in (MAZE_SIZE.y + 1)/2:
			
			set_cell(MAZE_POS.x + 2 * x , MAZE_POS.y + 2 * y, PATH_ID)
	
	#get cells
	cells = get_used_cells_by_id(PATH_ID)
	#generate maze
	var c = 0
	randomize()
	while visited_cells.size() < cells.size():
		var neighbours = neighbours_have_not_been_visited(current_cell)
		if neighbours.size() > 0:
			var random_neighbour = neighbours[randi()%neighbours.size()] #<- idk how randi()%neighbours.size() works but it replaces the choice in pythhon
			stack.push_front(current_cell)
			var wall = (random_neighbour - current_cell)/2 + current_cell
			set_cell(int(wall.x), int(wall.y), PATH_ID)
			current_cell = random_neighbour
			visited_cells.append(current_cell)
		elif stack.size() > 0:
			current_cell = stack[0]
			stack.pop_front()
		c+=1
	for i in cells:
		var cell_type = list[randi()%list.size()]
		if cell_type == 0 or cell_type == 1 and i != get_node('../Player').position:
			get_parent().get_node('spawn_m').set_cellv(i,cell_type)
		elif cell_type == 10 and i != get_node('../Player').position:
			get_parent().get_node("traps").set_cellv(i,0)
		else:
			set_cellv(i,cell_type)
			
	

func neighbours_have_not_been_visited(cell):
	var neighbours = []
	for dir in DIRECTIONS:
		if not visited_cells.has(cell + dir) and get_cell(int(cell.x + dir.x), int(cell.y + dir.y)) != LIMIT_ID:
			neighbours.append(cell + dir)
	return neighbours


func _process(delta):
	pass
