extends Node2D

@onready var uau_sfx = preload("res://sounds/uau.wav")

func _ready() -> void:
	play_sfx(uau_sfx)

func play_sfx(sfx: AudioStream):
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	audio_player.stream = sfx
	
	audio_player.play()
	
	await audio_player.finished
	audio_player.queue_free()


func _on_timer_timeout() -> void:
	play_sfx(uau_sfx)
