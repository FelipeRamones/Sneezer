extends Area2D

var bullet_speed = 1000
var bullet_direction = Vector2() setget set_bullet_direction

var out_of_bounds_manager = null

onready var origin = global_position

var bullet_range = 150

func _ready():
	
	out_of_bounds_manager = VisibilityNotifier2D.new()
	add_child(out_of_bounds_manager)
	
	pass 
	
func _process(delta):
	translate(bullet_direction * bullet_speed * delta)
	
	if global_position.distance_to(origin) >= bullet_range:
		call_deferred("free")
		pass
	
	if !out_of_bounds_manager.is_on_screen():
		call_deferred("free")
		pass
	pass
	
func set_bullet_direction(value):
	bullet_direction = value
	rotation = bullet_direction.angle()
	pass
