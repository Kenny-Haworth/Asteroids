extends "res://weightlessClassic/Weightless.gd"

var Missile = preload("res://missileClassic/MissileClassic.tscn")

onready var ui = get_tree().current_scene.get_node("UI")

export(float) var acceleration = 7
export(float) var max_speed = 500
export(float) var spin_thrust = 4 #10 for powerup later
export(float) var missile_speed = 550
export(float) var recharge_time = .35 #for controlling the delay between shots

var safeSpawnRadius = 150
var thrust = Vector2()
var rotation_dir = 0
var recharge_timer = 0
var initialPosition
var initialRotation
var ship
var need_to_respawn = false
var overrideSpawn = false
var fireSound
var thrusterSound

func _ready():
	set_max_contacts_reported(1)
	initialPosition = position
	initialRotation = rotation
	
	fireSound = AudioStreamPlayer.new()
	self.add_child(fireSound)
	fireSound.stream = load("res://soundsClassic/fireClassic.wav")
	
	thrusterSound = AudioStreamPlayer.new()
	self.add_child(thrusterSound)
	thrusterSound.stream = load("res://soundsClassic/thrustClassic.wav")
	pass

func _process(delta):
	
	#increase velocity when up arrow is pressed
	if (Input.is_action_pressed("ui_up") and not need_to_respawn):
		thrust = Vector2(acceleration, 0)
		thrusterSound.play()
	else:
		thrust = Vector2()
		
	#set rotation direction when arrow keys are pressed
	if (Input.is_action_pressed("ui_left")):
		rotation_dir = -1
	elif (Input.is_action_pressed("ui_right")):
		rotation_dir = 1
	else:
		rotation_dir = 0
		
	if (Input.is_action_pressed("P") and need_to_respawn):
		overrideSpawn = true
		
	#fire the gun
	if (Input.is_action_pressed("ui_accept")):
		if (recharge_timer <= 0 and not need_to_respawn):
			fireSound.play()
			var missile = Missile.instance()
			missile.position = position + Vector2(24, 0).rotated(rotation)
			missile.rotation = rotation
			missile.linear_velocity = Vector2(missile_speed, 0).rotated(rotation)
			get_parent().add_child(missile) #spawns a new missile
			recharge_timer = recharge_time
			
	recharge_timer -= delta
	
	#applies rotation and thrust to the ship
	set_angular_velocity(rotation_dir * spin_thrust)
	var vel = get_linear_velocity()
	vel += thrust.rotated(rotation)
	vel = vel.clamped(max_speed)
	set_linear_velocity(vel)
	pass

func _integrate_forces(state):
	
	#removes a life if the ship has collided with an asteroid
	var contacts = state.get_contact_count()
	for i in range(contacts):
		var contact = state.get_contact_collider_object(i)
		if contact.get_script().has_script_signal("explode"): #if the ship touches an asteroid
		
			contact.emit_signal("explode") #destroy the asteroid
			#grant points for destroying the asteroid with your ship
			if (contact.size == 2): #20 points for large
				ui.increase_score(20)
				bangLarge.play()
			elif (contact.size == 1): #50 points for medium
				ui.increase_score(50)
				bangMedium.play()
			elif (contact.size == 0): #100 points for small
				ui.increase_score(100)
				bangSmall.play()
			
			ui.decrease_health() #lose a life
			
			if (ui.get_health() >= 0): #the ship needs to be "respawned"
				need_to_respawn = true
				set_collision_layer_bit(1, 0)
				set_collision_mask_bit(0, 0)
				hide()

	if (need_to_respawn):
		var asteroids = get_tree().current_scene.get_node("Level").get_children()
		var safe = true
		
		for asteroid in asteroids:
			if asteroid.is_class("RigidBody2D"):
				if ((asteroid.position - initialPosition).length() <= safeSpawnRadius):
					safe = false
					break
			pass
		
		if (safe or overrideSpawn):
			state.transform = Transform2D(initialRotation, initialPosition)
			set_linear_velocity(Vector2())
			set_collision_layer_bit(1, 1)
			set_collision_mask_bit(0, 1)
			show()
			need_to_respawn = false
			overrideSpawn = false
			pass
		pass
			
	._integrate_forces(state)
	pass