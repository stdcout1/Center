extends KinematicBody2D

const MOVE_SPEED = 400
const GRAVITY = 50
const FLOOR = Vector2 (0, - 1)

var velocity = Vector2()

var direction = 1

func _ready():
	pass 

func _physics_process(delta):
	velocity.x = MOVE_SPEED * direction
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
		$Sprite.flip_h = !$Sprite.flip_h
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	


