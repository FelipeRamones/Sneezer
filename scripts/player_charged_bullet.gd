extends Area2D

var super_bullet_speed = 1100
var super_bullet_direction = Vector2() setget set_super_bullet_direction

var out_of_bounds_manager = null

onready var origin = global_position

var super_bullet_range = 250

func _ready():
	out_of_bounds_manager = VisibilityNotifier2D.new()
	add_child(out_of_bounds_manager)
	pass 
	
func _process(delta):
	translate(super_bullet_direction * super_bullet_speed * delta)
	
	if global_position.distance_to(origin) >= super_bullet_range:
		call_deferred("free")
		pass
	
	if !out_of_bounds_manager.is_on_screen():
		call_deferred("free")
		pass
	pass
	
func set_super_bullet_direction(value):
	super_bullet_direction = value
	rotation = super_bullet_direction.angle()
	pass