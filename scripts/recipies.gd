extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var panel = $VBoxContainer/Panel 
onready var sub_texture = $VBoxContainer/Panel/ScrollContainer/MarginContainer/GridContainer/TextureRect 

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.get_parent().remove_child(panel)
	sub_texture.get_parent().remove_child(sub_texture)
	for i in GlobalTileMap.recipies.keys():
		#print(GlobalTileMap.recipies[i])
		var kip = panel.duplicate()
		$VBoxContainer.add_child(kip)
		kip.name = i
		kip.get_node("TextureRect2").texture = load(GlobalTileMap.items[i][1])
		for ing in GlobalTileMap.recipies[i].keys():
			var kipp = sub_texture.duplicate()
			kip.get_node("ScrollContainer/MarginContainer/GridContainer").add_child(kipp)
			kipp.name = ing
			kipp.texture = load(GlobalTileMap.items[ing][1])
			kipp.get_node("RichTextLabel").text = str(GlobalTileMap.recipies[i][ing])
	
	
	
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
