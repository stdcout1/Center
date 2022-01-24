extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var orig = Main.orig_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var cplayer_health = Main.health
	#updating health 
	value = (cplayer_health/orig) * 100
