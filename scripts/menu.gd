extends Control

const RES_X = 1024
const RES_Y = 512
const block_size = 32
	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_start_menu():
	var dir = Directory.new()
	dir.remove("user://loaded.load")
	get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.


func _on_load():
	var loaded = true
	var loading = File.new()
	loading.open("user://loaded.load", File.WRITE)
	loading.store_line(str(loaded))
	loading.close()
	get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.
	


func _on_TextureButton3_pressed():
	get_tree().change_scene("res://dungeon/scene/main.tscn")
	pass # Replace with function body.
