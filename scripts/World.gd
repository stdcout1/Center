extends Node2D

#fundementals to know

#script = code file, for example, TileMap script means the code file that the TileMap scene uses

#nodes is how godot operates, different nodes have different properties and methods which allow for different uses

#a tree of nodes is called a scene, therefore, this is what we called the world scene which consists of all the nodes
#that affect the gameplay of the player when hes in the open world of the game

#in godot you can make a code file global which means it can be accessed globally between all code files no matter their location
#this is useful as it allows for a path of connection between all codefiles 

#the script that we assigned to be global is the TileMap script, GlobalTileMap = TileMap script
#you will see this alot in the code files

const RES_X = 1024
const RES_Y = 512
const block_size = 32
const mine_range = 2
const last = "5" #cave block index, this is the background of the exploration world

#these are a couple of variables that allow easy access to different scenes and nodes.
#what this is basically saying is that as soon as this script is ready, basically as soon as it starts
#access these nodes and scenes and assign them to said variable
#the $ variables are accessing nodes which are children of this node, and the preload variables are 
#loading scenes from the files using a directory
onready var Map = $TileMap
onready var Player = $player
onready var camera = $player/Camera2D
onready var sprite = $player/Sprite
onready var portal = preload("res://scenes/portal.tscn")
onready var mushroom = preload("res://scenes/mushroom.tscn")
onready var preassure_plate = preload("res://scenes/Preassure Plate.tscn")
onready var bomb = preload("res://scenes/bomb.tscn")

var render_distance = 32
var done = NAN
var build_cave = false
var lavapit = false
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
var orig_mouse_pos
var loadh
var level

# Called when the node enters the scene tree for the first time.
func _ready():
	var loading = File.new()
	loading.open("user://loaded.load", File.READ)
	loadh = loading.get_line()
	loading.close()
	var dir = Directory.new()
	dir.remove("user://loaded.load")
	
	if loadh == "True":
		#open the file and take each varible and put them in place
		var save_file = File.new()
		save_file.open("user://savegame.save", File.READ)
		var data = parse_json(save_file.get_line())
		loadd_m(data)
		Player.position = Vector2(data['pos_x'], data['pos_y'])
		camera.set_offset(Vector2(int(RES_X/2)-Player.position.x,0))
		loadinv(data["inventory"])
		done = data["done"]-1
		print(done)
		print(Player.position/Vector2(32,32))
		build_cave = data["build_cave"]
		n = data["n"]
		m = data["m"]
		left_cavex = data["left_cavex"]
		right_cavex = data["right_cavex"]
		create_cave = data["create_cave"]
		cave_start = data["cave_start"]
		cave_starty = data["cave_starty"]
		cave_start2 = data["cave_start2"]
		cave_start3 = data["cave_start3"]
		cave_start4 = data["cave_start4"]
		save_file.close()
		
		if Main.loot:
			print(Main.loot)
			for i in Main.loot.keys():
				GlobalTileMap.inv[i] = GlobalTileMap.items[i]
				GlobalTileMap.inv[i][0] = Main.loot[i]
		Main.loot = {}
		GlobalTileMap.update_inv = true
		
	else:
		gen_m()
func loadd_m(dict):
	var y = 0
	for i in dict['map']:
		var x = 0
		for e in i:
			Map.set_cell(x,y,e)
			x+= 1
		y += 1
func loadinv(list):
	for i in list:
		GlobalTileMap.inv[i] = list[i]


func gen_t(line):# this function is called every single time a new line needs be generated, which basically means every team the player goes down a block that theyve never gone down before
	#line is the y coordinate of the line that is about to be generated
	
	#uses add to gen function which was created to so that we can programmatically add blocks 
	#to the generation list which is in the global tilemap script
	level = line
	if line > 550:#limit at the bottom
		for i in range(0,int(RES_X/block_size)):
			Map.set_cell(i,line,8)
		return
	addtogen([0,30], '3', 4)
	addtogen([30,INF], '3', 3)
	addtogen([30,INF], '6', 3)
	addtogen([30,INF], '7', 1)
	#uses the add to gen function to add the block that allows for caves to spawn in the world back to the gen list
	#this is because the block is removed from the gen list as soon as a single one spawns in the world as that means a cave is being built
	#therefore is a cave is not being built then add the block to the gen list
	if !build_cave:
		addtogen([20,INF], last, 1)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0,int(RES_X/block_size)):#this is a for loop that gives the x coordinates for the block, as it loops from 0 to 31, since the world is 32 blocks wide
		var number = rng.randi_range(0,len(GlobalTileMap.world_vals)-1)#a random number is selected between the range of zero and 1 less than the size of the gen list
		var block = int(GlobalTileMap.world_vals[number])#this uses that number as an index and accesses the block that will be used in the generation of this specific coordinate
		Map.set_cell(i,line,int(GlobalTileMap.world_vals[number]))#this uses the coordinates and and the identity of block to set the cell in the world as the block that is randomly picked
		if line == 500:
			Map.set_cell(4,line,int(last))
			block = 5
		
		if block == int(last) and !build_cave:#checks if the block that was just generated is a cave block, if thats true then save some key coordinates and start cave generation
			build_cave = true
			cave_start = i
			cave_starty = line
			cave_start2 = i+1
			cave_start3 = i-1
			cave_start4 = i-2
			GlobalTileMap.gen_list[1].erase(last)#erases the cave block from the from the gen list
			GlobalTileMap.gen()#remakes the gen list so that it does not contain the cave block
			create_cave = [cave_start,cave_start2,cave_start3,cave_start4]

#building the cave
#how it works
#                 1   2   3   4        1   2   3   4       the code gets 4 base coordinates
#               1   2   3   4            1   2   3   4    and branches off in two directions from those 4 coordinates
#             1   2   3   4                1   2   3   4  by subracting and adding to the original x values and then making all those coordinates cave blocks
	if build_cave:
		if cave_start4-left_cavex < 0: #boundary checks that prevent the cave from going past the borders
			m = -1
		if cave_start2-left_cavex > 31:
			m = 1
		if cave_start2+right_cavex > 31:
			n = -1
		if cave_start4+right_cavex <0:
			n = 1
		left_cavex = left_cavex+m
		right_cavex = right_cavex+n

		for p in create_cave:
			Map.set_cell(p,line,int(last))
		create_cave = [
			cave_start+right_cavex,cave_start-left_cavex,
			cave_start2+right_cavex,cave_start2-left_cavex,
			cave_start3+right_cavex,cave_start3-left_cavex,
			cave_start4+right_cavex,cave_start4-left_cavex]
		
#adding random objects in the cave
#all of the variables below are random variables that will be used to decide if certain entities should spawn
#they are also split into two sides as there is too sides to the cave
		var mushroom_chance_side1 = randi() % 5 #range between 0 - 5
		var pplate_chance_side1 = randi() % 20 # range between 0 - 20 and so on
		var mushroom_chance_side2 = randi() % 5
		var pplate_chance_side2 = randi() % 20
		var side_chance = randi() % 2
		if left_cavex-m >= 2:
		#add preassure plates
			if pplate_chance_side1 == 1: #if we can spawn the preassure plate on side 1
				if m == 1: #if the cave has not been flipped, also meaning it has not reached the boundery yet
					if cave_start2-(left_cavex-m) >= 3:#if the cave is already three blocks into generation, since if they spawn in the air
						#mind you since this code is the same for spawning it was copied and pasted but the variable name wasnt changed
						#this is spawning the preassure plate and not mushrooms
						var mushroom_posx = Map.map_to_world(Vector2(cave_start2-(left_cavex-m), line)).x + 16
						var mushroom_posy = Map.map_to_world(Vector2(cave_start2-(left_cavex-m), line)).y + 16
						var instance = preassure_plate.instance()#instances in the preassure plate scene
						instance.position.x = mushroom_posx#and sets its location to being at the bottom the cave
						instance.position.y = mushroom_posy
						add_child(instance)#adds the scene to the world therefore making it visible
						#all of the following code follows the same guidelines as this
				elif m == -1:
					if cave_start4-(left_cavex-m) >= 3:
						var mushroom_posx = Map.map_to_world(Vector2(cave_start4-(left_cavex-m), line)).x + 16
						var mushroom_posy = Map.map_to_world(Vector2(cave_start4-(left_cavex-m), line)).y + 16
						var instance = preassure_plate.instance()
						instance.position.x = mushroom_posx
						instance.position.y = mushroom_posy
						add_child(instance)
			if mushroom_chance_side1 == 3:
				if m == 1:
					var mushroom_posx = Map.map_to_world(Vector2(cave_start2-(left_cavex-m), line)).x + 16
					var mushroom_posy = Map.map_to_world(Vector2(cave_start2-(left_cavex-m), line)).y + 26
					var instance = mushroom.instance()
					instance.position.x = mushroom_posx
					instance.position.y = mushroom_posy
					add_child(instance)
				elif m == -1:
					var mushroom_posx = Map.map_to_world(Vector2(cave_start4-(left_cavex-m), line)).x + 16
					var mushroom_posy = Map.map_to_world(Vector2(cave_start4-(left_cavex-m), line)).y + 26
					var instance = mushroom.instance()
					instance.position.x = mushroom_posx
					instance.position.y = mushroom_posy
					add_child(instance)
			if pplate_chance_side2 == 1:
				if n == 1:
					if cave_start4+(right_cavex-n) <= 28:
						var mushroom_posx = Map.map_to_world(Vector2(cave_start4+(right_cavex-n), line)).x + 16
						var mushroom_posy = Map.map_to_world(Vector2(cave_start4+(right_cavex-n), line)).y + 16
						var instance = preassure_plate.instance()
						instance.position.x = mushroom_posx
						instance.position.y = mushroom_posy
						add_child(instance)
				elif n == -1:
					if cave_start2+(right_cavex-n) <= 28:
						var mushroom_posx = Map.map_to_world(Vector2(cave_start2+(right_cavex-n), line)).x + 16
						var mushroom_posy = Map.map_to_world(Vector2(cave_start2+(right_cavex-n), line)).y + 16
						var instance = preassure_plate.instance()
						instance.position.x = mushroom_posx
						instance.position.y = mushroom_posy
						add_child(instance)
			if mushroom_chance_side2 == 3:
				if n == 1:
					var mushroom_posx = Map.map_to_world(Vector2(cave_start4+(right_cavex-n), line)).x + 16
					var mushroom_posy = Map.map_to_world(Vector2(cave_start4+(right_cavex-n), line)).y + 26
					var instance = mushroom.instance()
					instance.position.x = mushroom_posx
					instance.position.y = mushroom_posy
					add_child(instance)
				elif n == -1:
					var mushroom_posx = Map.map_to_world(Vector2(cave_start2+(right_cavex-n), line)).x + 16
					var mushroom_posy = Map.map_to_world(Vector2(cave_start2+(right_cavex-n), line)).y + 26
					var instance = mushroom.instance()
					instance.position.x = mushroom_posx
					instance.position.y = mushroom_posy
					add_child(instance)

		if line >= cave_starty+30 and cave_starty != 0: #if the cave has dug equal to or over 30 blocks from the original start position, stop cave building and reset variables
			build_cave = false
			var portal_posx = Map.map_to_world(Vector2(cave_start2+(right_cavex-n),line)).x - 32
			var portal_posy = Map.map_to_world(Vector2(cave_start2+(right_cavex-n),line)).y 
			var instance = portal.instance() #this is the portal scene and this is spawned at the end of every cave
			instance.position.x = portal_posx
			instance.position.y = portal_posy
			add_child(instance)
			if line >= 500 and instance:
				print(instance.get_children())
				instance.get_node("Label").visible = true
			left_cavex = 0
			right_cavex = 0 
			n = 1
			m = 1
		
	Map.set_cell(-1,line,4)#sets boundary blocks at the edges of the screen which are not visisble so that the player does not go off the edge
	Map.set_cell(RES_X/block_size,line,4)
	
func gen_m(): #this is a function which is only called once, at the start of the world so that the beginning of the world is generated

	for i in range(0,render_distance+9):#for the first 30 y coordinates generate a line for each coordinate
		gen_t(i)

	var mid = Vector2(int(RES_X/2),int(RES_Y/2))#this puts the player at the center of the screen
	Player.position = mid
	
	#clear landing area, also known as clearing the blocks where the player will spawn
	Map.set_cell(int(RES_X/(block_size*2)), int(RES_Y/(block_size*2)),int(last))
	Map.set_cell(int(RES_X/(block_size*2))+1, int(RES_Y/(block_size*2)),int(last))
	Map.set_cell(int(RES_X/(block_size*2))+1, int(RES_Y/(block_size*2))-1,int(last))
	Map.set_cell(int(RES_X/(block_size*2))-1, int(RES_Y/(block_size*2)),int(last))
	Map.set_cell(int(RES_X/(block_size*2))-1, int(RES_Y/(block_size*2))-1,int(last))
	Map.set_cell(int(RES_X/(block_size*2)), int(RES_Y/(block_size*2))-1,int(last))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
var do = false
func _process(delta):
	#            center                            -  
	var offset = Vector2(Player.position.x/32,ceil(Player.position.y/32 + render_distance))#checks if the player has gone down one block
	if Map.get_cellv(offset) == -1:#checks if a line has already been generated or not, if not then genreate a line of blocks
		gen_t(offset.y)
		done = offset.x

	#in the project settings theres an input map which assigns different keys names 
	if Input.is_action_just_pressed("invd"):#this key closes and opens the inventory, "tab"
		$TileMap/CanvasLayer2/TabContainer.visible = !$TileMap/CanvasLayer2/TabContainer.visible
	if Input.is_action_just_pressed("Mouse_button_left"):#this key starts the digging timer that limits how fast you can dig
		$DigTimer.start(GlobalTileMap.digging_time)
		orig_mouse_pos = get_global_mouse_position()#saves the mouse position where digging started
	if Input.is_action_pressed("Mouse_button_left"):#during key being held down
		if Map.world_to_map(get_global_mouse_position()) != Map.world_to_map(orig_mouse_pos):#check if the mouse position has changed
			$DigTimer.stop()#if so stop the original timer
			$DigTimer.start(GlobalTileMap.digging_time)#and restart it
			orig_mouse_pos = get_global_mouse_position()#then resave the mouse position
	if Input.is_action_just_released("Mouse_button_left"):#if the mouse button is released
		$DigTimer.stop()#stop the timer
		
func save_t(line):
	var linen = []
	for i in range(0,int(RES_X/block_size)):
		linen.append(Map.get_cell(i,line))
	return linen
		
		

#mining blocks
func mine(block): #takes the position of the mouse
	var blockk = Map.get_cellv(block)
	var blockkk = Map.tile_set.tile_get_name(blockk)#finds out the name of the block
	var inv = GlobalTileMap.inv
	if blockkk in GlobalTileMap.mineable_blocks:#checks if the block is mineable
		$player/mining.play()#plays the mining sound
		#then depending on the name of the block add the block to inventory, or if its already there then add one to the amount
		if blockkk == "organic_block":#this is special only for one block which is the organic block because it provides more than one item
			if !("stick" in inv):
				inv["stick"] = GlobalTileMap.items["stick"]
				inv["stick"][0] += randi() % 4
			else:
				inv["stick"][0] += randi() % 3
		else:
			if blockkk in inv:
				inv[blockkk][0] += 1
			else:
				inv[blockkk] = GlobalTileMap.items[blockkk]
				inv[blockkk][0] += 1
		Map.set_cellv(block,int(last))#finally remove the block from the world
	GlobalTileMap.update_inv = true#and update the inventory of the player
	

	
#placing blocks
func place(block): #takes the position of the mouse
	var blockk = Map.get_cellv(block)
	var inv = GlobalTileMap.inv
	var blockkk = Map.tile_set.tile_get_name(blockk)#gets the name of the block at your map position
	if GlobalTileMap.equiped != "":#checks if you have an item equipped
		#checks if the location of the mouse is empty, and if the mouse position is the same as the players, and if equipped item is a block
		if (blockk == -1 or blockk == int(last)) and inv[GlobalTileMap.equiped][0] > 0 and (GlobalTileMap.equiped in GlobalTileMap.mineable_blocks) and (Map.world_to_map(Player.position) != block ):
			inv[GlobalTileMap.equiped][0] -= 1#if everything is true subtract one from the item in the inventory
			Map.set_cellv(block,Map.tile_set.find_tile_by_name(GlobalTileMap.equiped)) #set the block in the world to whatever block that was equipped

	
func valid(curpos, target):
	curpos = Map.world_to_map(curpos)#gets position of player
	target = Map.world_to_map(target)#gets positiong of mouse
	#stolen from pythagoras lol
	#uses op formula to calculate viable blocks. nice and natuural
	#better explained it checks if the position between the player and mouse exceeds two blocks
	#if not then return valid, this limits the distance the player can mine
	return pow((target.x - curpos.x),2) + pow((target.y - curpos.y),2) <= pow(mine_range+1,2)


var r 
func _unhandled_input(event):#function that runs every frame and checks for events such as mouse clicks 
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if !GlobalTileMap.equiped == "":
				if GlobalTileMap.inv[GlobalTileMap.equiped][-1] == "bomb" and len(get_tree().get_nodes_in_group('bomb')) <= 3:
					r = GlobalTileMap.inv[GlobalTileMap.equiped][3]
					r = 3
					var instance = bomb.instance()
					var mouse_pos = Vector2(event.position-Vector2(RES_X/2,RES_Y/2))
					Player.add_child(instance)
					instance.add_collision_exception_with(Player)
					instance.position = Vector2(0,0)
					instance.fire(get_global_mouse_position())
					return
			

		if event.button_index == BUTTON_RIGHT and event.pressed:#if the right mouse button is clicked then called onto the place function, and give player position and mouse position
			place(Map.world_to_map(Vector2(event.position.x, camera.get_camera_position().y + event.position.y ))-Vector2(0,int(RES_Y/(block_size*2))))


func explode(pos):
#intresting huh?
#     1 2 3 
#	1 
#	2 	b
#	3

#removes blocks around the bomb and returns the items it removes in the inventory, if it is an organic it will rtandomly gives sticks
	$explode.position = pos
	$explode.play()
	GlobalTileMap.inv['bomb'][0] -= 1
	var current_pos = Map.world_to_map(pos)
	var inital = current_pos - Vector2(r,r)
	for y in range(0,pow(r,2)):
		for x in range(0,pow(r,2)):
			var block = Map.get_cell(inital.x+x,inital.y+y)
			var blockk = Map.tile_set.tile_get_name(block)
			if block == -1:
				return
			var inv = GlobalTileMap.inv
			if blockk in GlobalTileMap.mineable_blocks:
				if blockk == "organic_block":
					if !("stick" in inv):
						inv["stick"] = GlobalTileMap.items["stick"]
						inv["stick"][0] += randi() % 4
					else:
						inv["stick"][0] += randi() % 3
				else:
					if blockk in inv:
						inv[blockk][0] += 1
					else:
						inv[blockk] = GlobalTileMap.items[blockk]
						inv[blockk][0] += 1
			Map.set_cell(inital.x+x,inital.y+y,int(last))
	GlobalTileMap.update_inv = true
		
func addtogen(rag: Array , thing: String, level: int): # epic self documentation hack
	var offset = Map.world_to_map(Player.position) + Vector2(0,int(RES_Y/(block_size*2)))
	if offset.y >= rag[0] and offset.y <= rag[1]:#checks if the player has reached the range in which the block can now spawn
		if thing in GlobalTileMap.gen_list[level]:#if so and if the block is already in the gen list then do nothing and return
			return
		GlobalTileMap.gen_list[level].append(thing)#if not then append the append the block to the gen list
	elif thing in GlobalTileMap.gen_list[level]:#if the player is out of range of where the block spawns and the block is in the gen list
		GlobalTileMap.gen_list[level].erase(thing)#then remove the block from the gen list
	GlobalTileMap.gen()#regenrate the list that is used for generation

func _on_save():
	#save all important things in json
	var map = []
	var offset = Vector2(Player.position.x/32,ceil(Player.position.y/32 + render_distance))
	for i in range(0,offset.y):
		#for every line save as indivdual array, index of array is block x pos and array number is y [[1,3,4],[3,2,1]]
		map.append(save_t(i))
	var save_dict = {
	"pos_x" : Player.position.x, # Vector2 is not supported by JSON
	"pos_y" : Player.position.y,
	"map" : map,
	"inventory": GlobalTileMap.inv,
	"done": done,
	"build_cave": build_cave,
	"lavapit": lavapit,
	"n": n,
	"m": m,
	"left_cavex": left_cavex,
	"right_cavex": right_cavex,
	"create_cave": create_cave,
	"cave_start":cave_start,
	"cave_starty":cave_starty,
	"cave_start2": cave_start2,
	"cave_start3": cave_start3,
	"cave_start4": cave_start4
	}
	
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()
	


func _on_Timer_timeout():#whenever this timer goes off it gives out a signal
	var mouse_pos = get_global_mouse_position()#on this signal a mine is blocked
	if valid(Player.position, mouse_pos):
		mine(Map.world_to_map(mouse_pos))


func _on_TextureButton_pressed():
	$TileMap/CanvasLayer3/MarginContainer2.visible = false


func _on_TextureButton2_pressed():
	#change to dungeon or boss depending of level
	_on_save()
	GlobalTileMap.posi = position.x
	if level < 500:
		get_tree().change_scene("res://dungeon/scene/main.tscn")
	else:
		get_tree().change_scene("res://boss/scene/main.tscn")
