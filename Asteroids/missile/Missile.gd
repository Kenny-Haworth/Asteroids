extends "res://weightless/Weightless.gd"

onready var ui = get_tree().current_scene.get_node("UI")
var despawnTime = 900 #in milliseconds, this is .9 seconds
var scoreMultiplier = 1
var spawnTime

func _ready():
	set_max_contacts_reported(1)
	spawnTime = OS.get_ticks_msec()
	pass
	
func _process(delta):
	if (OS.get_ticks_msec() - spawnTime > despawnTime):
		queue_free()
	pass

func _integrate_forces(state):
	var contacts = state.get_contact_count()
	for i in range(contacts):
		var contact = state.get_contact_collider_object(i)
		
		if contact.get_script().has_script_signal("explode"):
			contact.emit_signal("explode")
			
			#increases the scoreboard for each type of asteroid destroyed
			if (contact.size == 2): #20 points for large
				ui.increase_score(20*scoreMultiplier)
			elif (contact.size == 1): #50 points for medium
				ui.increase_score(50*scoreMultiplier)
			elif (contact.size == 0): #100 points for small
				ui.increase_score(100*scoreMultiplier)
			
			queue_free()
			sleeping = true
			
	._integrate_forces(state)
	pass