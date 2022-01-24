extends Node2D


onready var waterbody = preload("res://scenes/WaterBody.tscn")
var instance


func _ready():
	instance = waterbody.instance()
	instance.position.x = 128
	instance.position.y = 352
	instance.depth = 128
	instance.spread = 0.0002
	instance.damp = 0.43
	add_child(instance)
	pass
func _process(delta):
	pass
