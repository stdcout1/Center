extends KinematicBody2D

# Node references
var player
# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 200
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0
var screen_size
var cooldown
var moving
func _ready():
	screen_size = get_viewport_rect().size
	player = get_tree().root.get_node("Node2D/Player")
	rng.randomize()
	
func _on_Timer_timeout():
	# Calculate the position of the player relative to the skeleton
	var player_relative_position = player.position - position
	
	if player_relative_position.length() <= 16:
		# If player is near, don't move but turn toward it
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
		moving = false
	elif player_relative_position.length() <= 100 and bounce_countdown == 0:
		# If player is within range, move toward it
		moving = true
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		# If player is too far, randomly decide whether to stand still or where to move
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
			moving = false
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
			moving = true
	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1

func _physics_process(delta):
	var movement = direction * speed * delta
	if moving:
		$AnimationPlayer.play("moving")
	if direction < Vector2.ZERO:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	var collision = move_and_collide(movement)
	if collision != null and collision.collider.name != "Player": #CHECK IF RAN INTO WALL
		direction = direction.rotated(rng.randf_range(PI/4, PI/2)) #CICLE BOUNCE PI COOLIO
		bounce_countdown = rng.randi_range(2, 5)
	if collision and collision.collider.name == "Player" and cooldown:
		#play attack 
		$AudioStreamPlayer2D.play()
		Main.alive[name][0] -= Main.alive[name][1]
		Main.health -= Main.alive[name][1]
		cooldown = false
		pass
		


func _on_attack_cd_timeout():
	$AudioStreamPlayer2D.stop()
	cooldown = true
	pass # Replace with function body.
