extends TextureRect


#set a couple of variables at the beginning
var data = {}
var armor = false
var release = false

func _ready():
	expand = true
	


#the next three functions are prebuilt functions in which we added code into to allow for drage and drop
func get_drag_data(position):
	if texture != null:#first check if there is a texture at whatever your clicking
		if str(GlobalTileMap.inv[get_parent().name][-2]) != "equipment":#if so check if that item is equipment
			data["origin_number"] = get_parent().get_child(1).text#if not then save its number and its text
			data["origin_text"] = get_parent().get_child(1)
		data["origin_node"] = self#save the data of the node
		data["origin_name"] = get_parent().name#save its name
		data["origin_texture"] = texture#save the texture
		
		#this allows the texture to stick to the mouse and to increase in size by expanding
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(100,100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		return data #return the data collected

func can_drop_data(position, data):
#when you move the texture and hover over a new texture this function tells you if its possible for this item to move to that location
	if get_parent().get_parent().get_parent().get_parent().get_parent().name != "Armor":
		if texture == null:#if this is the furnace check whether its possible to drop data
			if data["origin_name"] in GlobalTileMap.d_inv.keys():
				GlobalTileMap.d_inv.erase(data["origin_name"])
			release = true
			return true
		else:
			return false
	else:#else if its the armor section then check if its possible to drop the data
		if texture == null and name == str(GlobalTileMap.inv[data["origin_name"]][-1]):
			release = false
			return true
		else:
			return false

var c = 0
func drop_data(position, data):#this function only runs if it is possible for the data to drop
	#what this function does is that it takes the data collected and transfers it to the new panel
	#and at the same time it removes all that data from the original panel
	if release:
		if data["origin_name"] in GlobalTileMap.armor:
			GlobalTileMap.armor.erase(data["origin_name"])
	elif !release:
		GlobalTileMap.armor.append(data["origin_name"])
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
		data["origin_text"].text = ""
		get_parent().get_child(1).text = data["origin_number"]
	
