extends KinematicBody2D

var velocity: = Vector2.ZERO
var jump_vel: = -1000
var gravity: = 4000
var speed: = 500

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_down"):
		gravity = 40
		$CollisionShape2D.disabled = !$CollisionShape2D.disabled
		velocity.y += 10
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_vel
	
	
