extends CharacterBody2D

class_name Player

signal took_damage

@export var SPEED = 400
@export var ACCELEARTION = 10.0
@export var MAX_SPEED = 200
@export var STOPPING_TIME = 5.0

var can_attack = true

var lives = 3
var rocket_scene = preload("res://scenes/rocket.tscn")
var input_vector :Vector2

@onready var rocket_basket = $RocketBasket
@onready var shooting_socket = $ShootingSocket

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	player_movement()

func player_movement():
	input_vector = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if input_vector == Vector2(0, 0):
		velocity = velocity.move_toward(Vector2.ZERO, STOPPING_TIME)
	
	velocity += input_vector * ACCELEARTION
	
	velocity.limit_length(MAX_SPEED)
	move_and_slide()
	look_at(get_viewport().get_mouse_position())
	
	# get_viewport_rect().size
	var screen_size = get_viewport_rect().size
#	global_position = global_position.clamp(Vector2.ZERO, screen_size)	

	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	
func shoot():
	if can_attack:
		var rocket_instance = rocket_scene.instantiate()
		rocket_instance.global_position = shooting_socket.global_position
		rocket_instance.rotation = $Sprite2D.global_rotation
		rocket_basket.add_child(rocket_instance)
	
func take_damage():
	emit_signal("took_damage")
	
func die():
	print("player died")
	queue_free()

func respawn():
	set_collision_layer_value(1, true)
	get_node("Sprite2D").visible = true
	set_physics_process(true)
	can_attack = true

func paused(new_position):
	position = new_position
	set_collision_layer_value(1, false)
	get_node("Sprite2D").visible = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	can_attack = false
