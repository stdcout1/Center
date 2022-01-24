extends TextureRect
var data = {}
var yo = false
var armor = false
var release = false

func _ready():
	expand = true
	pass # Replace with function body.


	
func get_drag_data(position):
	if texture != null:
		if str(GlobalTileMap.inv[get_parent().name][-3]) != "weapon":
			print(data)
			data["origin_number"] = get_parent().get_child(1).text
			data["origin_text"] = get_parent().get_child(1)
		data["origin_node"] = self
		data["origin_name"] = get_parent().name
		print (data["origin_name"])
		data["origin_texture"] = texture
		yo = true
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(100,100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		return data 

func can_drop_data(position, data):
	if get_parent().get_parent().get_parent().get_parent().get_parent().name != "Armor":
		if texture == null and "weapon" == str(GlobalTileMap.inv[data["origin_name"]][-3]) and !(data["origin_name"] in GlobalTileMap.d_inv.keys()):
			release = true
			return true
		else:
			return false
	else:
		
		if texture == null and "weapon" == str(GlobalTileMap.inv[data["origin_name"]][-3]):
			release = false
			return true
		else:
			return false

var c = 0
func drop_data(position, data):
	if release:
		GlobalTileMap.d_inv[data["origin_name"]] = GlobalTileMap.inv[data['origin_name']]
	c = 0
	for x in data["origin_node"].get_parent().get_parent().get_children():
		if x.name == data["origin_name"]:
			x.name = GlobalTileMap.orig_names[c]
			break
		c += 1
	data["origin_node"].texture = null
	texture = data["origin_texture"]
	get_parent().name = data["origin_name"]
	if str(GlobalTileMap.inv[get_parent().name][-2]) != "equipment":
		data["origin_number"] = get_parent().get_child(1).text
		data["origin_text"] = get_parent().get_child(1)


	
