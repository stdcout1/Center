extends ScrollContainer


var craftable = false
var recipies = GlobalTileMap.recipies
var count = 1
onready var panel = $GridContainer/Panel
var thing = NAN

func _ready():
	
	panel.get_parent().remove_child(panel)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	#foreground
	if not visible:
		return
	for i in $GridContainer.get_children():
		#clear the grid container
		$GridContainer.remove_child(i)
		i.queue_free()
	for loot in Main.loot.keys():
		#add the thigns in the loot list with textures and stuff
		var kip = panel.duplicate()
		kip.name = loot
		kip.visible = true
		kip.get_child(0).texture = load(GlobalTileMap.items[loot][1])
		kip.get_child(1).text = str(Main.loot[loot])
		$GridContainer.add_child(kip)
		
		#$GridContainer.get_node(loot).get_child(0).texture = load(GlobalTileMap.items[loot][1])

func fair(thing):
	#check if the thing already exitits
	for i in $GridContainer.get_children():
		if thing == i.name:
			return true
	return false		
