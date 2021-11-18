extends KinematicBody2D

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
		
