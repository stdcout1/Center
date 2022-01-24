extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(2,2)
var dmg

# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = Main.enemies[get_parent().name][1]
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
	var p = get_tree().get_root().get_node("Node2D").get_child(0)
	if p == body:
		Main.health -= dmg
		#if bullet eenemy hits player
	
	queue_free()
		
