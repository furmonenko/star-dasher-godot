extends Control

func set_score(new_score):
	$Panel/ScoreLabel.text = "Score: " + str(new_score)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
