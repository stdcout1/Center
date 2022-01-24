extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mg = $GridContainer/MarginContainer
onready var Player = get_tree().get_root().get_node("Node2D/Player")
onready var TileM = get_tree().get_root().get_node("Node2D/TileMap")
var loop = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	#add eveything in the dinv to the hotbar
	mg.get_parent().remove_child(mg)
	for i in Main.inv.keys():
		var kip = mg.duplicate()
		kip.name = i
		kip.get_node("Panel/TextureProgress").texture_progress = load(GlobalTileMap.items[i][1])
		$GridContainer.add_child(kip)
		
	pass # Replace with function body.

func potion(name: String,index: String): #name is type
	#use a potion based on name and index of it in the hotbar
	var item = Main.inv[index]
	if item[0] != 0:
		item[0] -= 1
		match name:
			"heal":
				Main.health += item[3]
			"strength":
				start_potion(name,index)
func start_potion(potion,index):
	#start a potion timer
	var item = Main.inv[index]
	for i in  Player.get_children():
		if i.is_in_group(name):
			return
	match potion:
		"strength":
			Player.dmg += item[3]
	var timer = Timer.new()
	Player.add_child(timer)
	timer.add_to_group(potion)
	timer.connect("timeout",self,"stop_potion",[potion,index])
	timer.start(item[4])
	


func stop_potion(potion,index):
	print(potion, 'wore off')
	for i in Player.get_children():
		if i.is_in_group(potion):
			i.queue_free()




func use(index: int):
	var item = GlobalTileMap.items[$GridContainer.get_child(index).name]
	match item[-1]: #select case OMG #this is a op hack, no matter what item is in any posiiotn of the hotbar you can use it. Its super op
		"potion":
			var type = item[2]
			potion(type,str($GridContainer.get_child(index).name))
			print(Main.inv)
		"sword":
			var ability = item[4]
			var abname = ability[0]
			match abname:
				"Slash":
					#check if anything I slash is killable
					var space_state = get_world_2d().direct_space_state
					var thing = $GridContainer.get_child(index).name
					for i in  Player.get_children():
						if i.is_in_group(thing):
							return
					var timer = Timer.new()
					
					$GridContainer.get_child(index).get_node("Panel/TextureProgress").value = 0
					#SLASH
					var slashv = 300
					var slashh = 200
					var hit = (Player.get_node("Area2D").get_overlapping_bodies())
					#ADD THE SLASH MECHANIC LOL
					# I DID :D
					for i in hit:
						if i != Player and i != TileM and Main.alive and !(i is TileMap):
							Main.alive[i.name][0] -= ability[1]
							item[3] -= 1
							Player.get_node("Area2D").get_child(0).get_child(0).visible = true
						#cooldown
					Player.add_child(timer)
					timer.add_to_group(thing)
					#cooldown 
					timer.connect("timeout",self,"cd",[timer,index,thing])
					loop = 1
					timer.start(0.001)
				
			 
			
		
func cd(timer,index,thing):
	if loop > 60:
		for i in Player.get_children():
			if i.is_in_group(thing):
				print(i)
				Player.get_node("Area2D").get_child(0).get_child(0).visible = false
				i.queue_free()
	$GridContainer.get_child(index).get_node("Panel/TextureProgress").value = loop
	loop += 1
	#update the loop cooldown indicater thing based on time left
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in $GridContainer.get_children():
		var item = i.name
		i.get_node("Panel/RichTextLabel").text = str(Main.inv[item][0])
	#input detection
	if Input.is_action_just_pressed("one_input"):
		use(0)
	if Input.is_action_just_pressed("2_input"):
		use(1)
	if Input.is_action_just_pressed("3_input"):
		use(2)
