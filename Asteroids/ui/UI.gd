extends Control

#import scenes
onready var scoreNode = get_node("Score")
onready var healthNode = get_node("Health")

#grants an extra life
func increase_health():
	healthNode.health += 1
	pass
	
#removes a life
func decrease_health():
	healthNode.health -= 1
	if (healthNode.health < 0):
		get_tree().reload_current_scene()
	pass
	
#increases the score
func increase_score(amount):
	scoreNode.score += amount
	pass
	
func get_score():
	return scoreNode.score
	
func get_health():
	return healthNode.health