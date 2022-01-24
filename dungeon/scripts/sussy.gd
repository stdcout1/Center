extends KinematicBody2D

onready var BULLET_SCENE = preload("res://dungeon/scene/bullet_e.tscn")

var player = null
var Move= Vector2.ZERO
var speed = 300
const RES_X = 1024
const RES_Y = 512
func _physics_process(delta):
	Move= Vector2.ZERO
	
	if player != null:
		Move= position.direction_to(player.position) * speed
		$AnimationPlayer.play("move")
	else:
		Move= Vector2.ZERO

	Move= Move.normalized()
	Move = move_and_collide(Move)
	
func _on_Area2D_body_entered(body):
	if body == get_tree().get_root().get_node("Node2D").get_child(0):
		player = body

func _on_Area2D_body_exited(body):
	if body == get_tree().get_root().get_node("Node2D").get_child(0):
		player = null
	
func fire():
	var tc = Physics2DTestMotionResult.new()
	var bullet = BULLET_SCENE.instance()
	bullet.position = Vector2(0,0)
	add_child(bullet)
	bullet.add_collision_exception_with(self)
	var col = bullet.test_motion(to_local(player.position),true,0.08,tc)
	bullet.fire(to_local(player.position))
	if col and tc.collider != player:
		remove_child(bullet)
	else:
		bullet.get_node("AudioStreamPlayer2D").play()
		bullet.fire(to_local(player.position))
	
	
	#convert player position to local position
	
	
	
func _on_Timer2_timeout():
	if player != null:
		fire()


func _process(delta):
	pass






#melle 
""""
# Node references
var player
# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 400
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

func _ready():
	player = get_tree().root.get_node("Node2D/Player")
	rng.randomize()
	
func _on_Timer_timeout():
	# Calculate the position of the player relative to the skeleton
	var player_relative_position = player.position - position
	
	if player_relative_position.length() <= 16:
		# If player is near, don't move but turn toward it
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
	elif player_relative_position.length() <= 100 and bounce_countdown == 0:
		# If player is within range, move toward it
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		# If player is too far, randomly decide whether to stand still or where to move
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1

func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player": #CHECK IF RAN INTO WALL
		direction = direction.rotated(rng.randf_range(PI/4, PI/2)) #CICLE BOUNCE PI COOLIO
		bounce_countdown = rng.randi_range(2, 5)
	if collision and collision.collider.name == "Player":
		print('dead')
		


func _on_Area2D_body_entered(body):
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	pass # Replace with function body.


func _on_Timer2_timeout():
	pass # Replace with function body.
"""
