extends CharacterBody2D

class_name Enemy

@export var SPEED = 200

signal killed
signal died

var player_ref = null
var attack_direction = null
var movement_vector := Vector2.ZERO
var player_position := Vector2.ZERO
var collision = null

func _physics_process(delta: float) -> void:
	enemy_movement(delta)

func enemy_movement(delta):
	if player_ref:
		player_position = player_ref.global_position
		
		var player_enemy_distance = player_position - position
		var angle = player_enemy_distance.angle()
		var enemy_rotation = global_rotation
		
		global_rotation = lerp_angle(enemy_rotation, angle, randf_range(0.01, 0.1))	
		
		attack_direction = global_position.direction_to(player_position)
		velocity = attack_direction * SPEED
		
	collision = move_and_collide(velocity * delta)

func _process(delta: float) -> void:
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			collider.take_damage()
			die()

func _on_agro_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body

func die():
	emit_signal("died")
	queue_free()
	
func kill():
	emit_signal("killed")
	die()
