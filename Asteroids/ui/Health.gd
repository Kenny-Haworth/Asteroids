tool
extends GridContainer

var HealthIcon = preload("res://ui/HealthIcon.tscn")

export var health = 3 setget set_health

func _ready():
	set_health(health)
	pass

func set_health(newHealth):
	if (get_child_count() < newHealth):
		for i in range(get_child_count(), newHealth):
			var child = HealthIcon.instance()
			add_child(child)
			pass
			
	elif (get_child_count() > newHealth):
		for i in range(newHealth, get_child_count()):
			var child = get_child(newHealth)
			remove_child(child)
			pass
					
	health = newHealth
	pass