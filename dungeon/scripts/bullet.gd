extends RigidBody2D

#BULLET FOR THE PLAYER
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(2,2)
var dmg
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	dmg = get_parent().dmg
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func fire(pos):
	
	apply_central_impulse(pos*velocity)
func _on_kill_timeout():
	queue_free()
	pass # Replace with function body.


func _on_RigidBody2D_body_entered(body):
	
	for i in get_colliding_bodies():
		if !(i is TileMap) and !(i is StaticBody2D):
			Main.alive[i.name][0] -= dmg
	if body.name in Main.alive:
		queue_free()
