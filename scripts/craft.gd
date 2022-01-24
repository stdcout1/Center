extends ScrollContainer



var craftable = false
var recipies = GlobalTileMap.recipies
var count = 1
onready var panel = $GridContainer2/Panel
var thing = NAN

func _ready():
	preload("res://items/crafting_bench.png")
	panel.get_parent().remove_child(panel)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for recipie in recipies.keys():
		craftable = false
		thing = recipie
		recipie = recipies[recipie]
		count = 0
		for ing in recipie.keys(): #ing is ingrediants
			var val = recipie[ing]
			if ing in GlobalTileMap.inv.keys():
				if GlobalTileMap.inv[ing][0] - val >= 0:
					count += 1
			#count the amount of items need for the recipie
		if count == len(recipie.keys()):
			craftable = true
		#if the number of items matches the items the player has craftable is true
		var kip = panel.duplicate()
		if craftable and !fair(thing):
			kip.name = thing
			kip.visible = true
			print(panel)
			#if it is craftable and not already there add else
			$GridContainer2.add_child(kip)
			$GridContainer2.get_node(thing).get_child(0).texture = load(GlobalTileMap.items[thing][1])
			print( GlobalTileMap.items[thing][1])
			#make get_child(0) into more usefull
			#print("craft")
			craftable = false
		elif !craftable and fair(thing):
			#or else if its not craftable and is there, remove it
			$GridContainer2.remove_child($GridContainer2.get_node(thing))
func fair(thing):
	for i in $GridContainer2.get_children():
		if thing == i.name:
			return true
	return false		
