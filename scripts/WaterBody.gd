extends Node2D

#im not going to lie sir i created this at the beginning of the break and i only have a general idea what it does
#i also used a youtube video to do this
#the basic idea is that we make a polygon that has its top layer mad of man different lines
#those are the amounts of springs, which are also the amount of sections in the top layer of the polygon
#when the player enters the body of liquid and hits on the sections, the section then goes down,
#but then at the same time its corresponding sections do the opposite of what its doing but with less force
#and the same thing happens to the corresponding sections of the corresponding sections and so on
#and therefore a wave is created.

export var spring_constant = 0.015
export var damp = 0.09
export var spread = 0.0002


export var distance_between_springs = 16
export var spring_number = 35
export var change_factorx = 1
export var change_factory = 1
export var grav_reduction = 1800
export var lava = false

var water_legth = distance_between_springs * spring_number

onready var water_spring = preload("res://scenes/Water.tscn")

export var depth = 100
var target_height = global_position.y 
var bottom = target_height + depth

onready var water_polygon = $water_polygon

onready var water_border = $water_border
export var border_thickness = 0

onready var collision_shape = $water_body_area/CollisionShape2D
onready var water_body_area = $water_body_area

var springs = []
var passes = 8

func _ready():
	water_border.width = border_thickness
	
	spread = spread/1000
	
	
	for i in spring_number:
		var x_position = distance_between_springs * i 
		var w = water_spring.instance()
		
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", self, "splash")
	
	var total_length = distance_between_springs * (spring_number - 1)
	
	var rectangle = RectangleShape2D.new().duplicate()

	var rect_position = Vector2(total_length/2, depth/2)
	var rect_extents = Vector2(total_length/2, depth/2)
	
	water_body_area.position = rect_position
	rectangle.set_extents(rect_extents)
	collision_shape.set_shape(rectangle)
	splash(2,5)

func _physics_process(delta):
	bottom = target_height + depth
	for i in springs:
		i.water_update(spring_constant, damp)
		
	var left_deltas = []
	var right_deltas = []
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
		pass 
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	new_border()
	draw_water_body()


func draw_water_body():
	
	var curve = water_border.curve
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points 
	
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	water_polygon_points = PoolVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)
	
	pass

func new_border():
	
	var curve = Curve2D.new().duplicate()
	
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	curve.set_point_position(spring_number-1,Vector2(curve.get_point_position(spring_number-1).x,clamp(-5,0,10)))
	curve.set_point_position(0,Vector2(curve.get_point_position(0).x,clamp(-5,0,10)))
	
	water_border.curve = curve
	water_border.smooth(true)
	water_border.update()
	
	pass 

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed
	pass


func _on_water_body_area_body_exited(body):
	if body is TileMap:
		return
	if body is KinematicBody2D:
		body.GRAVITY = 1800.0
		body.change_factory = 1
		body.change_factorx = 1
		body.damage = 0
	pass

func _on_water_body_area_body_entered(body):
	if body is TileMap:
		return
	if body is KinematicBody2D:
		if lava:
			body.damage = 5
		body.change_factory = change_factorx
		body.change_factorx = change_factory
		body.GRAVITY = grav_reduction
	pass
