extends KinematicBody2D

export (int) var speed = 500

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_r"):
		velocity.x += 1
	if Input.is_action_pressed("move_l"):
		velocity.x -= 1
	if Input.is_action_pressed("move down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
