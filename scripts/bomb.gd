extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(2,2)
var r
onready var main = get_parent().get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	r = get_parent().get_parent().r
	add_to_group('bomb')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire(pos):
	apply_central_impulse(to_local(pos))
	
	
func expl(pos):
	print(self," was yoinked")
	apply_central_impulse(-(pos*r*3))
	
func nearby_er():
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var others = []
	for i in get_tree().get_nodes_in_group('bomb'):
		if i == self:
			continue
		var nearby = i.position
		var result = space_state.intersect_ray(to_global(Vector2(0,0)), nearby, [get_parent()])
		if result:
			#find the other bombs
			others.append(i)
	return others
	
func _on_kill_timeout():
	for i in nearby_er():
		#apply a velocity to opssoite direction 
		i.expl(position)
	get_parent().get_parent().explode(global_position)
	queue_free()
	pass # Replace with function body.

