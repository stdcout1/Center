extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var orig_health = 100.0
var health = 100.0
var enemies = {
	"sussy_m": [100,10,['stone','redgold']],
	"sussy": [100,10,['gold','stone']],
	"boss": [1000,10,['bomb','diamond']]
}
var alive = {}
var loot = {}
var gen = true
var waves  #<- 100 is the y lvl of portal please spawn portal every 50

onready var Cam = $Player/Camera2D
#TEST VARIBLES
var equppied = 0
var inv = GlobalTileMap.d_inv
#END OF TEST VARIBLES
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#int is done is player script
	#for i in enemies:
		#alive[i] = enemies[i]
	pass # Replace with function body.

var chopper = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i in loot.keys():
		if loot[i] == 0:
			loot.erase(i)
			#remove empty loot
	
	#kill dead enemies below
	chopper = []
	for i in alive:
		#mark zero hp enemies
		
		if alive[i][0] <= 0 and i != "boss":
			chopper.append(i)
	for i in chopper:
		print(i)
		var rng = RandomNumberGenerator.new()
		#remove them
		var drop = alive[i][-1][rng.randi_range(0,len(alive[i][-1])-1)]
		if drop in loot.keys():
			loot[drop] += 1
		else:
			loot[drop] = 1
		#print(loot)
		alive.erase(i)
		get_tree().get_root().get_node(i).queue_free()
	if health <= 0:
		#when dead load back into overworld
		var loaded = true
		var loading = File.new()
		loading.open("user://loaded.load", File.WRITE)
		loading.store_line(str(loaded))
		loading.close()
		get_tree().change_scene("res://scenes/World.tscn")
	pass
