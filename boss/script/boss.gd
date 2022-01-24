extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Player = get_parent().get_node("Player")
onready var enem_m = preload("res://dungeon/scene/sussy_m.tscn")
onready var bullet = preload("res://boss/scene/bullet_eb.tscn")
var phase = 1
var go = true
# Called when the node enters the scene tree for the first time.
func _ready():
	Main.alive['boss'] = Main.enemies['boss'].duplicate(true)
	Main.health = 100
	Main.alive["boss"][0] -= 1000
	print(get_parent())
	pass # Replace with function body.

var done = false

func _process(delta):
	#play idle animation
	if !$AnimationPlayer.is_playing() and !done:
		$AnimationPlayer.play("idle")
	
	$ProgressBar.value = Main.alive['boss'][0]
	
	if Main.alive['boss'][0] < 500 and !done:
		phase = 2
	if Main.alive['boss'][0] <= 0 and !done:
		$p1melle.stop()
		$spikeball.stop()
		$"radial laser v1".visible = false
		$"radial laser v2".visible = false
		$AnimationPlayer.play("death")
		phase = 3
		
	print(phase)
	match phase: #slect case for pahse
		1:
			
			if $p1melle.is_stopped():
				$p1melle.start()
			if $spikeball.is_stopped():
				$spikeball.start()
			$"radial laser v1".visible = false
			$"radial laser v2".visible = true
			
		2:
			if $p1melle.is_stopped():
				$p1melle.start()
			if $spikeball.is_stopped():
				$spikeball.start()
			$"radial laser v1".visible = true
			$"radial laser v2".visible = false
			pass


func _on_p1melle_timeout():
	
	for i in range(5):
		var x = -1
		var y = -1
		var center_x = Player.position.x
		var center_y = Player.position.y
		while ! (pow((x-center_x),2) + pow((y-center_y),2) <= pow(8*64,2) and x < 20*64 and x > 0 and y < 20*64 and y > 0 and go):
				#this looks for a random spot around the player and in the map. It will keep generating random numbers until a number is valid
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				x = rng.randi_range(-20*64,20*64)
				y = rng.randi_range(-20*64,20*64) #this is the range of all possible x and y vlaues
		#now spawn the enmy at the valid location:
		var instance = enem_m.instance()
		var pre_name = instance.name
		get_tree().get_root().add_child(instance)
		instance.add_to_group("enem")
		instance.position = Vector2(x,y)
		var post_name = instance.name
		Main.alive[post_name] = Main.enemies[pre_name].duplicate(true)
		
func _on_spikeball_timeout():
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, Player.position, [self])
	#raycast a spike ball to the player and check if he is obstructed
	if result:
		if result['collider'] == Player:
			#throw a spike ball at the player an dplay  teh sound
			var binstance = bullet.instance()
			
			binstance.add_collision_exception_with(self)
			add_child(binstance)
			binstance.get_node("AudioStreamPlayer2D")
			binstance.position = Vector2(0,0)
			binstance.fire((Player.position))
pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	#when animation of him dieing finishes go back to the overworld
	if anim_name == 'death':
		done = true
		$AnimationPlayer.stop()
		$Sprite.region_rect = Rect2(Vector2(11000,7000),Vector2(1000,1000))
		get_parent().get_node("AudioStreamPlayer").stop()
		$home.start(5)
		
"""
abilties:
	phase 1 > 1/2 health
	-throw spike ball
	-spawn melle AI
	-radial laser
	phase 2 1/2 to 0 hp
	-funny animination and yelling
	-radial lazer v2
	-spawns bombs
	-spawns mre melle
	


"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass









func _on_home_timeout():
	var loaded = true
	var loading = File.new()
	loading.open("user://loaded.load", File.WRITE)
	loading.store_line(str(loaded))
	loading.close()
	get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.
