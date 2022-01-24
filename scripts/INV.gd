extends GridContainer


var name_list = []
var orig_names = []
var c 

func _ready():
	
	var children = get_child(0).get_children()
	for x in children:
		GlobalTileMap.orig_names.append(x.name)
	#GlobalTileMap.inventory(get_child(0).get_children())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not visible:
		#print ("shit")
		return
	if GlobalTileMap.update_inv:
		print ("hello")
		print (get_child(1).name)
		#GlobalTileMap.inventory(get_child(0).get_children())




"""
	name_list = []
	var children = get_children()
	for x in children:
		name_list.append(x.name)
	#mark = []
	if !(GlobalTileMap.inv.empty()):
		for key in GlobalTileMap.inv.keys():
			c = 0
			if !(key in name_list):
				for i in children:
					if i.get_child(0).texture == null:
						if str(GlobalTileMap.inv[key][-2]) == "equipment" and !(key in GlobalTileMap.armor):
							i.get_child(1).text = ""
							i.get_child(0).texture = load((GlobalTileMap.inv)[key][1])
							i.name = key
							break
						elif str(GlobalTileMap.inv[key][-2]) != "equipment":
							i.get_child(1).text = str(GlobalTileMap.inv[key][0])
							i.get_child(0).texture = load((GlobalTileMap.inv)[key][1])
							i.name = key
							break
					c += 1
"""


