extends Node2D



func _ready():
	pass # Replace with function body.


var velocity = 0
var force = 0
var height = 0
var target_height = 0

var index = 0

var motion_factor = 0.02

var collided_with = null

signal splash

onready var collision = $Area2D/CollisionShape2D

func water_update(spring_constant, dampining):
	height = position.y
	var x = height - target_height
	var loss = - dampining * velocity 
	force = - spring_constant * x + loss
	velocity += force
	position.y += velocity
	pass


func initialize(x_position,id):
	height = position.y
	target_height = position.y 
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.get_extents()
	var new_extenets = Vector2(value/2, extents.y)
	collision.shape.set_extents(new_extenets)
	pass


func _on_Area2D_body_entered(body):
	if body is TileMap:
		return
	if body is KinematicBody2D:
		var speed = body.motion.y * motion_factor
		emit_signal("splash",index,speed)
	pass # Replace with function body.


