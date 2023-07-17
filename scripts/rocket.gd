extends Area2D

@export var SPEED = 500

@onready var on_screen_modifier = $VisibleOnScreenNotifier2D
@onready var launch_sound = preload("res://sounds/attack.wav")

var movement_vector = Vector2(0, -1)

func _ready() -> void:
	AudioPlayer.play_sfx(launch_sound)
	on_screen_modifier.connect("screen_exited", _on_screen_exited)

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * SPEED * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	body.kill()

func _on_area_entered(area: Area2D) -> void:
	if area is Meteor:
		var meteor = area
		queue_free()
		meteor.explode()
