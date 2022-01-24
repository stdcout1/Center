extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.bbcode_text = "[center]" + str(get_parent().get_parent().get_parent().get_node("player").position / Vector2(32,32)) + "[/center]"
