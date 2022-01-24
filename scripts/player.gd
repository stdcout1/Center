extends KinematicBody2D

#set some base variables
const MOVE_SPEED= 100
const MAX_FALL_SPEED = 1000
const JUMP_FORCE = 600

onready var sprite = $Sprite
onready var equipped = $Area2D/equipped
onready var idle_damage = $idle_damage

var y_velo = 0
var facing = 1
var screen_size
var attack_swipe = CollisionShape2D.new()
var motion = Vector2.ZERO
var GRAVITY = 1800.0
var change_factorx = 1
var change_factory = 1
var health = 100
var damage = 0
var start = false
var move = true
var direction = "idle"

func _physics_process(delta):
	if !($"Ambient music".playing):#if the ambient music is not playing then play it
		$"Ambient music".play()
	if health == 0:
		health = 100
	#if damage does not equal zero that means idle damage needs to be done to player and so start the timer for idle damage
	if damage != 0 and !start:
		idle_damage.start(1)
		start = true
	elif damage == 0:
		idle_damage.stop()
		start = false
	#get the size of the player view area
	screen_size = get_viewport_rect().size
	if GlobalTileMap.equiped != "":#if something is equipped then change the texture of the equipped to whatever is equipped
		var equipped_texture = load(GlobalTileMap.items[GlobalTileMap.equiped][1])
		equipped.set_texture(equipped_texture)
	else:
		equipped.texture = null#else if nothing is equipped then remove all textures

	var move_dir = 0#this is the variable used for moving the player which is reset every cycle
	if Input.is_action_pressed("move_r"):#if the d key is pressed then add 1 to move_dir meaning move to the right
		move_dir += 1
		direction = "walk_right"#this variable is used for the animation
		$Sprite.flip_h = false#flips the player so that they look to the right
		if $footsteps.playing == false and move and is_on_floor():#plays the footsteps sound
			$footsteps.play()
			$footsteps_time.start(0.5)
			move = false
	elif Input.is_action_pressed( "move_l"):#same thing but for left
		move_dir -= 1
		direction = "walk_left"
		$Sprite.flip_h = true
		if $footsteps.playing == false and move and is_on_floor():
			$footsteps.play()
			$footsteps_time.start(0.5)
			move = false 
	else:
		direction = "idle"#used for animation this means the player isnt moving 

	motion = Vector2 (move_dir * MOVE_SPEED, y_velo) 
	#sets motion as a vector that has an x value of the maximum speed of the player * its direction
	motion.x = motion.x * change_factorx
	#this is a change factor which is 1 by default but is there so when we want to make changes to the speed of the player in other scripts
	motion.y = motion.y * change_factory
	move_and_slide(motion, Vector2(0, -1))#move and slide is a function that moves the player based on the vector it is given
	var grounded = is_on_floor()#checks if the player is on the floor
	y_velo += GRAVITY * delta#adds gravity to the player by changing the y value for the movement vector also known as motion
	if is_on_ceiling():#checks if the player hit the ceiling, if so cancel the jump or set the y value to 0
		y_velo = 0
	if grounded and Input.is_action_just_pressed("jump"):#if space bar is clicked or pressed
		y_velo = -JUMP_FORCE#add jump force to the y value so that the player jumps
		$"jump sound".play()#play the jump sound

	if grounded and y_velo >= 5:
	#if the player is grounded make the y value of motion to 5 so that gravity doesnt add to the y value when the player is grounded
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:#if the y values is greater than maximum fall speed then make the y value the max fall speed
		y_velo = MAX_FALL_SPEED
	$AnimationPlayer.play(direction)#play an animation depending on the state of the player


func _on_idle_damage_timeout():
	health += -damage#if idle damage starts then damage will be taken by the player every time this timer goes off


func _on_footsteps_time_timeout():#this is a limiter to how fast the footsteps sound can play
	move = true
