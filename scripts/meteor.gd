extends Area2D
class_name Meteor

signal exploded(size, pos)

@onready var cshape = $CollisionShape2D
@onready var sprite = $Sprite2D

@export var speed = 100
var movement_vector = Vector2(1, 0)

enum MeteorSize {LARGE, SMALL}
@export var size = MeteorSize.LARGE

func _ready() -> void:
	rotation = randf_range(0, 2 * PI)
	
	match size:
		MeteorSize.LARGE:
			speed = 100
			cshape.shape = preload("res://resources/meteor_cshape_large.tres")
		MeteorSize.SMALL:
			speed = 200
			cshape.shape = preload("res://resources/meteor_cshape_small.tres")
			sprite.texture = preload("res://assets/meteor_detailedSmall.png")

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var screen_size = get_window().size
	var cshape_radius = cshape.shape.radius
	
	if global_position.x < 0 - cshape_radius:
		global_position.x = screen_size.x + cshape_radius
	elif global_position.x > screen_size.x + cshape_radius:
		global_position.x = 0 - cshape_radius
	if global_position.y < 0 - cshape_radius:
		global_position.y = screen_size.y + cshape_radius
	elif global_position.y > screen_size.y + cshape_radius:
		global_position.y = 0 - cshape_radius

func explode():
	emit_signal("exploded", size, position)
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		player.take_damage()
		# explode()
