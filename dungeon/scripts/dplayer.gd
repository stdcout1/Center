extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scene = preload("res://dungeon/scene/bullet.tscn")
onready var enem_r = preload("res://dungeon/scene/sussy.tscn")
onready var enem_m = preload("res://dungeon/scene/sussy_m.tscn")
onready var chest = preload("res://dungeon/scene/chest.tscn")
var speed = 400 
var screen_size
const RES_X = 1024
const RES_Y = 512
var dmg = 10
var collision
var wave = 0





onready var camera = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	#algorthm to determine diffuculty
	Main.waves = int(floor(GlobalTileMap.posi/100))
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	GlobalTileMap.dung = rng.randi_range(1,2) 
	print(Main.waves)
	randomize()
	var intro_songs = [preload("res://dungeon/res/sounds/Danny Rayel - Age of Dragons [HD 1080p].ogg"),preload("res://dungeon/res/sounds/Mattia Turzo & Jacopo Cicatiello - Dreamland.ogg"),preload("res://dungeon/res/sounds/Maxime Luft - Conquest Of Our Freedom (Heroic Adventure Action).ogg")]
	var choice = intro_songs[randi()%intro_songs.size()]
	get_parent().get_node("AudioStreamPlayer").stream = intro_songs[2]
	get_parent().get_node("AudioStreamPlayer").play()
	#LEVEL INT
	match GlobalTileMap.dung:
		1:
			$Camera2D.limit_bottom = -320
			$Camera2D.limit_right = 77*64
			$Camera2D.limit_top = -32*64
			$Camera2D.limit_left = 45*64
			position = Vector2(54*64,-11*64)
		2:
			#edit the camera limits based on map generation
			var n = 2*Main.waves + 15
			if (n)%2 == 0:
				n+=1
			$Camera2D.limit_bottom = (n+1)*64
			$Camera2D.limit_right = (n+1)*64
			$Camera2D.limit_top = 0*64
			$Camera2D.limit_left = 0*64
			position = Vector2(n*64+32, n*64+40)
			
			
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var prev = Vector2.ZERO
func _process(delta):
	#play walking sound
	if prev != global_position:
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
	prev = global_position
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("move_r"):
		velocity.x += 1
		$Sprite.flip_h = false
		$Area2D.position = Vector2(48,0)
		$Area2D.rotation_degrees = 0
		$AnimationPlayer.play("left")
	if Input.is_action_pressed("move_l"):
		velocity.x -= 1
		$Sprite.flip_h = true
		$Area2D.position = Vector2(-48,0)
		$Area2D.rotation_degrees = 0
		$AnimationPlayer.play("left")
	if Input.is_action_pressed("place"):
		velocity.y += 1
		$Area2D.position = Vector2(0,32)
		$Area2D.rotation_degrees = 90
		$AnimationPlayer.play("down")
	if Input.is_action_pressed("jump"):
		$Area2D.position = Vector2(0,-32)
		$Area2D.rotation_degrees = 90
		$AnimationPlayer.play("up")
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	
	#position += velocity * delta
	collision = move_and_collide(velocity*delta)
	if collision:
		
		#trap system
		var tm = get_parent().get_node("traps")
		if collision.collider is TileMap and collision.collider == tm: #checks if the collion of the player is part of the "trap" tile map.
			get_parent().get_node("traps").get_node("AudioStreamPlayer").play() #play trap sound
			for x in range(-1,2):
				for y in range(-1,2):
					#checks the sourrounding blocks of the player to check which trap he triggered
					var cellpos = tm.world_to_map(position) + Vector2(x,y)
					if tm.get_cellv(cellpos) != -1:
						tm.set_cellv(cellpos,1) #change tile to triggered state
			var timer = Timer.new()
			add_child(timer)
			timer.connect("timeout",self,"trap",[tm.world_to_map(position)]) #make a timer and a timeout to trap()
			timer.start(1) # <- timer time
			Main.health -= 10 # <- dmg
			
	match GlobalTileMap.dung:
		1:
			if wave <= Main.waves and !get_tree().get_nodes_in_group('enem'): # <- wave numbers
				for i in range(5): #<- enimies per wave
					var rng = RandomNumberGenerator.new()
					rng.randomize()
					match rng.randi_range(1,2):
						1:
							#melel spawner
							var spawn_locs = get_node("../spawn").get_used_cells_by_id(1)
							var instance = enem_m.instance()
							var pre_name = instance.name
							get_tree().get_root().add_child(instance)
							instance.add_to_group("enem")
							instance.position = spawn_locs[rng.randi_range(0,len(spawn_locs)-1)]*Vector2(64,64)
							var post_name = instance.name
							Main.alive[post_name] = Main.enemies[pre_name].duplicate(true) #use duplicated to ensure entire dicitnary is copied
						2:
							#ranged spawn
							var spawn_locs = get_node("../spawn").get_used_cells_by_id(0)
							var instance = enem_r.instance()
							var pre_name = instance.name
							get_tree().get_root().add_child(instance)
							instance.add_to_group("enem")
							instance.position = spawn_locs[rng.randi_range(0,len(spawn_locs)-1)]*Vector2(64,64)
							var post_name = instance.name
							Main.alive[post_name] = Main.enemies[pre_name].duplicate(true) #use duplicated to ensure entire dicitnary is copied
				wave +=1
			elif wave >= Main.waves and !get_tree().get_nodes_in_group('enem') and !get_node("../chest") :
				#spawn chest in predetermined location in "spawn" tilemap
				var chest_loc = get_node("../spawn").get_used_cells_by_id(2)
				var instance = chest.instance()
				instance.name = 'chest'
				get_tree().get_root().get_node("Node2D").add_child(instance)
				instance.position = chest_loc[0]*Vector2(64,64)
			
func trap(curp):
	#stop trap sound and reset the traps
	var tm = get_parent().get_node("traps")
	tm.get_node("AudioStreamPlayer").stop()
	for x in range(-1,2):
		for y in range(-1,2):
			var cellpos = curp + Vector2(x,y)
			if tm.get_cellv(cellpos) == 1:
				tm.set_cellv(cellpos,0)
	pass
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			var mouse_pos = get_local_mouse_position()
			if !("bow" in Main.inv): 
				#same thing as the other dplayer script check if the player has a bow
				if pow((mouse_pos.x),2) + pow((mouse_pos.y),2) <= pow(90,2):
					var space_state = get_world_2d().direct_space_state
					var result = space_state.intersect_ray(to_global(Vector2(0,0)), to_global(mouse_pos),[self])
					if result:
						if result["collider"].is_in_group('enem'):
							#check if what the player click is in range and not blocked by anythig then remove the damage
							Main.alive[result["collider"].name][0] -= int(GlobalTileMap.items[$CanvasLayer/Control/MarginContainer/GridContainer.get_child(0).name][2])
			else:
				#bow fire
				var instance = scene.instance()
				add_child(instance)
				instance.add_collision_exception_with(self)
				instance.position = Vector2(0,0)
				
				#instance.add_force(Vector2(0,0),mouse_pos)
				var t = mouse_pos*50/(mouse_pos-position)
				instance.fire(mouse_pos)
func _input(event):
	# loot inv
	if event.is_action_pressed("invd"):
		$CanvasLayer/UI.visible = !$CanvasLayer/UI.visible
			

