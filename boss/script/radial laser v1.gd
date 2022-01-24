extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$laser2/RayCast2D.add_exception(get_parent())
	pass # Replace with function body.



func _process(delta):
	if !visible:
		return
	if shoot: 
		
		if rotation_degrees >= 360:
			rotation_degrees = 0
		rotation_degrees += 0.5
		var x = $laser2/RayCast2D.get_collision_point().x - $laser_shooter.global_position.x
		var y = $laser2/RayCast2D.get_collision_point().y - $laser_shooter.global_position.y
		var c = sqrt((x*x)+(y*y))
		$laser2/laser.position.y = int(-c/2)
		$laser2/laser.scale.y = c/32
		$laser2/CollisionShape2D.position = $laser2/laser.position
		$laser2/CollisionShape2D.scale = $laser2/laser.scale




func _on_laser2_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		Main.health -= 5
		$Timer.start(0.5)
	pass # Replace with function body.


func _on_laser2_body_exited(body):
	if body == get_parent().get_parent().get_node("Player"):
		$Timer.stop()
	pass # Replace with function body.


func _on_Timer_timeout():
	Main.health -= 5
	pass # Replace with function body.
