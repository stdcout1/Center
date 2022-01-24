extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var scene = preload("res://dungeon/scene/bullet.tscn")
onready var enem_m = preload("res://dungeon/scene/sussy_m.tscn")
onready var song = preload("res://boss/res/sound/8-Bit Boss Battle - 4 - By EliteFerrex.ogg")
var speed = 400 
var screen_size
const RES_X = 1024
const RES_Y = 512
var dmg = 10
var collision
var wave = 0

func _ready():
	
	get_parent().get_node("AudioStreamPlayer").play()
	$Timer.start(get_parent().get_node("AudioStreamPlayer").stream.get_length())
	
	
	#Initate the boss level 
	
	var xl = 21
	var yl = 21
	# fix up camera
	$Camera2D.limit_bottom = yl*64
	$Camera2D.limit_right = xl*64
	$Camera2D.limit_top = -1*64
	$Camera2D.limit_left = -1*64
	$Camera2D.zoom = Vector2(1.25,1.25)
	
	#inital position of player
	position = Vector2(1,1)
	
	
	
	screen_size = get_viewport_rect().size
	pass # Replace with function body.
var prev = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _process(delta):
	#start the walk effect is the player is moving 
	if prev != global_position:
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
	prev = global_position
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("move_r"):
		#if the player moved right play the animation and move him
		velocity.x += 1
		$Sprite.flip_h = false
		$Area2D.position = Vector2(48,0)
		$Area2D.rotation_degrees = 0
		$AnimationPlayer.play("left")
	if Input.is_action_pressed("move_l"):
		#if the player moved ledt play the animation and move him
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
		#player moving fown
	if Input.is_action_pressed("jump"):
		$Area2D.position = Vector2(0,-32)
		$Area2D.rotation_degrees = 90
		$AnimationPlayer.play("up")
		velocity.y -= 1
	if velocity.length() > 0:
		#allows for smooth movement and accelration
		velocity = velocity.normalized() * speed
	
	
	#position += velocity * delta
	#collision varible; not used here but still allows for percise calculations
	collision = move_and_collide(velocity*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#check if left click is pressed
			var mouse_pos = get_local_mouse_position()
			if !("bow" in Main.inv):
				#check if the player has a bow
				#if not do the following 
				if pow((mouse_pos.x),2) + pow((mouse_pos.y),2) <= pow(90,2):
					#check if mouse click is in radius (pythgrous therom)
					var space_state = get_world_2d().direct_space_state
					var result = space_state.intersect_ray(to_global(Vector2(0,0)), to_global(mouse_pos),[self])
					if result:
						#raycast upon the player to check for any colliosns if there are none then we move on
						if result["collider"].is_in_group('enem'):
							Main.alive[result["collider"].name][0] -= int(GlobalTileMap.items[$CanvasLayer/Control/MarginContainer/GridContainer.get_child(0).name][2])
			else:
				#spawn bullet stuff
				var instance = scene.instance()
				add_child(instance)
				instance.add_collision_exception_with(self)
				instance.position = Vector2(0,0)
				var t = mouse_pos*50/(mouse_pos-position)
				instance.fire(mouse_pos)
func _input(event):
	#open loot
	if event.is_action_pressed("invd"):
		$CanvasLayer/UI.visible = !$CanvasLayer/UI.visible
		
			


	pass # Replace with function body.


func _on_Timer_timeout():
	#play laught and song
	get_parent().get_node("AudioStreamPlayer").stop()
	get_parent().get_node("AudioStreamPlayer").stream = song
	get_parent().get_node("AudioStreamPlayer").play()
	pass # Replace with function body.
