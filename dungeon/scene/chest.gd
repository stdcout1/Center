extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var looted = false
var rarm  = Main.waves/2
var rarity = [
	[
		['coal',10],
		['iron',5],
	],
	[
		['stone',60],
		['copper',10],
		['coal',10],
		['iron',5]
	],
	[
		['bomb_s',4],
		['health1_pot',6],
		['coal',30],
		['iron',10]
	],
	[
		['bow',1],
		['bomb_s',5]
	],
	[
		['bomb_s',6],
		['health1_pot',8],
	],
	[
		['bomb_s',10],
		['health1_pot',10]
	],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
	
		if event.button_index == BUTTON_LEFT and event.pressed and $Sprite.get_rect().has_point(get_local_mouse_position()) and looted == false:
			$AnimatedSprite.play()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var item = rarity[rarm][rng.randi_range(0,len(rarity[rarm])-1)]
			#give a random thing for the possibel loot based on dpeth
			# loot is sotred in {redgold:15, stone:10} format
			if item[0] in Main.loot.keys():
				Main.loot[item[0]] += item[1] 
			else:
				Main.loot[item[0]] = item[1] 
			looted = true
			$Timer.start(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 2
	
	pass # Replace with function body.


func _on_Timer_timeout():
	

	var loaded = true
	var loading = File.new()
	loading.open("user://loaded.load", File.WRITE)
	loading.store_line(str(loaded))
	loading.close()
	get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.
