extends Control

@onready var score_label = $ScoreLabel
@onready var lives = $LIVES

func update_score(new_score):
	score_label.text = "Score: " + str(new_score)

func lost_life(current_lives):
	lives.get_children()[current_lives].visible = false
	
func gained_life(current_lives):
	print("gained life: " + str(current_lives))
	if (current_lives <= 3):
		lives.get_children()[current_lives].visible = true
