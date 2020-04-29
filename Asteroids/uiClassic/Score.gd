#controls the scoreboard
#tool means that it is called automatically by Godot

tool
extends Label

export var score = 0 setget set_score

func _ready():
	set_score(score)

func set_score(newScore):
	text = "" + String(newScore)
	score = newScore
