extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shoot = false
var look = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$laser2/RayCast2D.add_exception(get_parent())
	$Timer.start(8)
	$laser2.position = $laser_shooter.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		return
	var player_pos = get_parent().get_parent().get_node("Player").global_position
	if $laser_shooter.rotation_degrees >= 360:
		$laser_shooter.rotation_degrees = 0
	if $laser_shooter.rotation_degrees >= -360:
		$laser_shooter.rotation_degrees = 0
	if look:
		look_at(player_pos)
		$laser2.visible = false
	if shoot:
		get_parent().get_node("AnimationPlayer").play("laser")
		var x = $laser2/RayCast2D.get_collision_point().x - $laser_shooter.global_position.x
		var y = $laser2/RayCast2D.get_collision_point().y - $laser_shooter.global_position.y
		var c = sqrt((x*x)+(y*y))
		$laser2/laser.position.x = int(c/2)
		$laser2/laser.scale.x = c/32
		$laser2/CollisionShape2D.position = $laser2/laser.position
		$laser2/CollisionShape2D.scale = $laser2/laser.scale
		$laser2.visible = true 
		


func _on_Timer_timeout():
	$Timer.stop()
	$Timer2.start(0.5)
	look = false


func _on_Timer2_timeout():
	$Timer2.stop()
	shoot = true
	$reset.start(2)


func _on_laser2_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		Main.health -= 5
		
	pass # Replace with function body.


func _on_reset_timeout():
	look = true
	shoot = false
	$Timer.start(1)
	pass # Replace with function body.
