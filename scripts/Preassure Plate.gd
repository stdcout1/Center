extends Area2D


onready var lava = preload("res://scenes/WaterBody.tscn")
var spawn_waterbody = false


func _process(delta):
	var current_pos = get_parent().get_child(1).world_to_map(position)
	#checks if theres a block under it, if not then delete the preassure plate
	if get_parent().get_child(1).get_cell(current_pos.x, current_pos.y+1) == 5 or get_parent().get_child(1).get_cell(current_pos.x,current_pos.y) != 5:
		queue_free()#delets the preassure plate
	if spawn_waterbody:#spawns the body of liquid whether its lava or water
		#does some math to set the position properly and clears all the blocks where the liquid is going to be
		var Map = get_parent().get_child(1)
		var map_pos = Map.world_to_map(position)
		var final_point = Vector2.ZERO
		for x in range (0,20):
			Map.set_cell(map_pos.x,map_pos.y+x-1,5)
			Map.set_cell((map_pos.x)-1,map_pos.y+x-1,5)
			Map.set_cell((map_pos.x)+1,map_pos.y+x-1,5)
			final_point = Vector2(map_pos.x-1,map_pos.y+x-1)
		final_point.x -= 2
		final_point.y += 1
		for y in range(0,3):
			if y < 2:
				for x in range(0,7):
					Map.set_cell(final_point.x+x,final_point.y+y,5)
				Map.set_cell(final_point.x-1,final_point.y+y,8)
				Map.set_cell(final_point.x+7,final_point.y+y,8)
			else:
				for x in range(0,9):
					Map.set_cell(final_point.x-1+x,final_point.y+y,8)
		var lava_coords = Map.map_to_world(final_point)
		var instance = lava.instance()
		#edits the properties of the body of liquid
		instance.lava = true#sets lava to true
		instance.spring_number = 15#this is the length of the body
		instance.depth = 64#this is how deep it goes
		instance.position = lava_coords#these are its coords
		instance.damp = 0.43#this decides how viscouse the body is
		instance.spread = 0.0002#this decides how much spread there amoungs the surface of the liquid
		instance.change_factorx = 0.5#this changes the speed of the player on the x values
		instance.change_factory = 0.2#this changes the speed of the player on the y values
		instance.grav_reduction = 100#this changes the effect of gravity on the player 
		instance.get_child(0).color = Color(0.764706, 0.360784, 0)#this changes the color of the body of the liquid
		instance.get_child(1).color = 0x000000#this changes the color of the line following the surface of the liquid
		get_parent().add_child(instance)#this adds the body of liquid to the game so its visible and interactable
		queue_free()#this delets the preassure 



func _on_Preassure_Plate_body_entered(body):
	spawn_waterbody = true
	return body
