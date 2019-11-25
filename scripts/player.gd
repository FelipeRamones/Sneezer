extends KinematicBody2D

var bullet = preload('res://scenes/game_objects/player_bullet.tscn')
var super_bullet = preload('res://scenes/game_objects/player_charged_bullet.tscn')

var is_ready_to_charge = true
var is_already_charged = false
onready var label = get_node('../label_timer')

var walk_speed = 500
var screen_size

# To control the timer wich controls when the bigger bullet will come out
var charger = null
# To control how long the timer is gonna take before allowing the big bullet
var charging_seconds = 1

func _ready():
	charger = Timer.new()
	charger.set_one_shot(true)
	charger.set_wait_time(charging_seconds)
	charger.connect("timeout", self, "_bullet_charged")
	add_child(charger)
	
	screen_size = get_viewport_rect().size
	set_position(screen_size / 2)
	set_process(true)
	pass
	
func _process(delta):
	label.set_text(str(charger.get_time_left()))
	look_at(get_global_mouse_position())
	_move_player(delta)
	_shoot_bullet()
	pass
	
func _bullet_charged():
	is_already_charged = true
	pass

func _shoot_bullet():
	if Input.is_action_just_pressed("player_shoot"):
		var new_bullet = bullet.instance()
		new_bullet.global_position = $player_mouth.global_position
		new_bullet.bullet_direction = Vector2(cos(rotation), sin(rotation)).normalized()
		get_parent().add_child(new_bullet)
		pass
	if Input.is_action_pressed("player_shoot"):
		if is_ready_to_charge == true:
			is_ready_to_charge = false
			charger.start()
			pass
		pass
	if Input.is_action_just_released("player_shoot"):
		if is_ready_to_charge == false:
			is_ready_to_charge = true
			charger.stop()
			if is_already_charged == true:
				is_already_charged = false
				
				charger.stop()
				var new_bullet = super_bullet.instance()
				new_bullet.global_position = $player_mouth.global_position
				new_bullet.super_bullet_direction = Vector2(cos(rotation), sin(rotation)).normalized()
				get_parent().add_child(new_bullet)
				#modulate = Color(255, 255, 255)
				charger.set_wait_time(charging_seconds)
				pass
			pass
		pass
	pass
	
func _move_player(delta):
	
	var playerX = 0
	var playerY = 0
	
	if Input.is_action_pressed("ui_right"):
		playerX += 1
		pass
	if Input.is_action_pressed("ui_left"):
		playerX -= 1
		pass
		
	if Input.is_action_pressed("ui_up"):
		playerY -= 1
		pass
		
	if Input.is_action_pressed("ui_down"):
		playerY += 1
		pass
		
	translate(Vector2(playerX, playerY).normalized() * delta * walk_speed)
	pass
