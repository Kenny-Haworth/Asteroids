extends "res://weightless/Weightless.gd"

var Missile = preload("res://missile/Missile.tscn")
var shipFlame = preload("res://ship/shipTwo.png")
var shipNoFlame = preload("res://ship/spaceShips_004.png")

onready var ui = get_tree().current_scene.get_node("UI")
onready var spriteShip = get_node("Sprite")

export(float) var acceleration = 7
export(float) var max_speed = 500
export (float) var spin_thrust = 4
export (float) var missile_speed = 550
export(float) var recharge_time = .35 #for controlling the delay between shots

var safeSpawnRadius = 175
var thrust = Vector2()
var rotation_dir = 0
var recharge_timer = 0
var initialPosition
var initialRotation
var ship
var need_to_respawn = false
var playingCreepySound = false
var overrideSpawn = false

var disableMissile = false
var canonFireRateUp = false
var spawnMissileCircle = false
var missileDelay = false
var extraScore = false
var extraSpin = false
var scoreMultiplier = 1
var numCircles = 0
var powerupGrabTimeExtraLife
var powerupGrabTimeRapidFire
var powerupGrabTimeMissileCircle
var powerupGrabTimeDelay
var powerupGrabTimeScore
var powerupGrabTimeLegendary
var powerupGrabTimeConfused
var powerupGrabTimeDisableMissile
var powerupDisableTime = 8000 #8 seconds
var powerupDisableTime2 = 3000 #3 seconds

#Debuffs
var invis = false
var powerupGrabTimeInvis
var fastrocks = false
var powerupGrabTimeFastRocks
var asteroid_speed_multiplier = 2.5
var overdrive = false
var powerupGrabTimeOverdrive
var powerupGrabTimeNoMissile

var fireSound
var fireSoundLoud
var thrusterSound
var shipExplosion
var rapidFire
var extraShip
var clock
var gunJam
var scoreUp
var confused
var confuseSound
var scoreDown
var loseLife
var moveFaster
var creepy1
var ivisibleSound

func _ready():
	set_max_contacts_reported(1)
	initialPosition = position
	initialRotation = rotation

	fireSound = AudioStreamPlayer.new()
	self.add_child(fireSound)
	fireSound.stream = load("res://sounds/fire2.wav")
	fireSound.volume_db = -45

	fireSoundLoud = AudioStreamPlayer.new()
	self.add_child(fireSoundLoud)
	fireSoundLoud.stream = load("res://sounds/fire2.wav")
	fireSoundLoud.volume_db = -25

	clock = AudioStreamPlayer.new()
	self.add_child(clock)
	clock.stream = load("res://sounds/clock.wav")
	clock.volume_db = 0

	thrusterSound = AudioStreamPlayer.new()
	self.add_child(thrusterSound)
	thrusterSound.stream = load("res://sounds/engineSound2.wav")
	thrusterSound.volume_db = -22

	shipExplosion = AudioStreamPlayer.new()
	self.add_child(shipExplosion)
	shipExplosion.stream = load("res://sounds/shipExplosion.wav")
	shipExplosion.volume_db = -5

	rapidFire = AudioStreamPlayer.new()
	self.add_child(rapidFire)
	rapidFire.stream = load("res://sounds/rapidFire2.wav")
	rapidFire.volume_db = -20

	scoreUp = AudioStreamPlayer.new()
	self.add_child(scoreUp)
	scoreUp.stream = load("res://sounds/scoreUp.wav")
	scoreUp.volume_db = -20

	scoreDown = AudioStreamPlayer.new()
	self.add_child(scoreDown)
	scoreDown.stream = load("res://sounds/scoreDown.wav")
	scoreDown.volume_db = -25

	gunJam = AudioStreamPlayer.new()
	self.add_child(gunJam)
	gunJam.stream = load("res://sounds/gunJam.wav")
	gunJam.volume_db = -20
	
	loseLife = AudioStreamPlayer.new()
	self.add_child(loseLife)
	loseLife.stream = load("res://sounds/loseLife.wav")
	loseLife.volume_db = -20
	
	moveFaster = AudioStreamPlayer.new()
	self.add_child(moveFaster)
	moveFaster.stream = load("res://sounds/moveFaster.wav")
	
	confuseSound = AudioStreamPlayer.new()
	self.add_child(confuseSound)
	confuseSound.stream = load("res://sounds/confuse.wav")
	confuseSound.volume_db = -15
	
	ivisibleSound = AudioStreamPlayer.new()
	self.add_child(ivisibleSound)
	ivisibleSound.stream = load("res://sounds/invis.wav")

	creepy1 = AudioStreamPlayer.new()
	self.add_child(creepy1)
	creepy1.stream = load("res://sounds/Harrowing.wav")
	creepy1.volume_db = -15

	extraShip = AudioStreamPlayer.new()
	self.add_child(extraShip)
	extraShip.stream = load("res://sounds/extraShip2.wav")
	extraShip.volume_db = -20
	pass

func _process(delta):

	if (disableMissile and OS.get_ticks_msec() > powerupGrabTimeDisableMissile + powerupDisableTime):
		disableMissile = false
	if (canonFireRateUp and OS.get_ticks_msec() > powerupGrabTimeRapidFire + powerupDisableTime2):
		recharge_time = .35
		canonFireRateUp = false
	if (missileDelay and OS.get_ticks_msec() > powerupGrabTimeDelay + powerupDisableTime):
		missileDelay = false
	if (extraScore and OS.get_ticks_msec() > powerupGrabTimeScore + powerupDisableTime):
		extraScore = false
		scoreMultiplier = 1
		scoreDown.play()
	if (extraSpin and OS.get_ticks_msec() > powerupGrabTimeLegendary + powerupDisableTime2):
		extraSpin = false
		spin_thrust = 4

	#Debuffs
	if (invis and OS.get_ticks_msec() > powerupGrabTimeInvis + powerupDisableTime):
		invis = false
		show()
	if (fastrocks and OS.get_ticks_msec() > powerupGrabTimeFastRocks + powerupDisableTime):
		fastrocks = false
		var asteroids = get_tree().current_scene.get_node("Level").get_children()
		for asteroid in asteroids:
			if asteroid.is_class("RigidBody2D"):
				asteroid.linear_velocity = asteroid.get_linear_velocity() / asteroid_speed_multiplier
	if (overdrive and OS.get_ticks_msec() > powerupGrabTimeOverdrive + powerupDisableTime):
		overdrive = false
	if (confused and OS.get_ticks_msec() > powerupGrabTimeConfused + powerupDisableTime):
		confused = false

	if (spawnMissileCircle and OS.get_ticks_msec() > powerupGrabTimeMissileCircle + (1000*recharge_time*numCircles)):
		fireSoundLoud.play()
		var missile = Missile.instance()
		missile.position = position + Vector2(30, 25/2).rotated(rotation)
		missile.rotation = rotation
		missile.linear_velocity = Vector2(missile_speed, 0).rotated(rotation)
		get_parent().add_child(missile) #spawns a new missile

		fireSoundLoud.play()
		var missile1 = Missile.instance()
		missile1.position = position + Vector2(30, -25/2).rotated(rotation)
		missile1.rotation = rotation
		missile1.linear_velocity = Vector2(missile_speed, 0).rotated(rotation)
		get_parent().add_child(missile1) #spawns a new missile

		fireSoundLoud.play()
		var missile2 = Missile.instance()
		missile2.position = position + Vector2(0, 35).rotated(rotation)
		missile2.rotation = rotation + deg2rad(90)
		missile2.linear_velocity = Vector2(0, missile_speed).rotated(rotation)
		get_parent().add_child(missile2) #spawns a new missile

		fireSoundLoud.play()
		var missile3 = Missile.instance()
		missile3.position = position + Vector2(0, -35).rotated(rotation)
		missile3.rotation = rotation - deg2rad(90)
		missile3.linear_velocity = Vector2(0, -missile_speed).rotated(rotation)
		get_parent().add_child(missile3) #spawns a new missile

		fireSoundLoud.play()
		var missile4 = Missile.instance()
		missile4.position = position + Vector2(30, 30).rotated(rotation)
		missile4.rotation = rotation + deg2rad(45)
		missile4.linear_velocity = Vector2(missile_speed/2, missile_speed/2).rotated(rotation)
		get_parent().add_child(missile4) #spawns a new missile

		fireSoundLoud.play()
		var missile5 = Missile.instance()
		missile5.position = position + Vector2(-30, -30).rotated(rotation)
		missile5.rotation = rotation + deg2rad(225)
		missile5.linear_velocity = Vector2(-missile_speed/2, -missile_speed/2).rotated(rotation)
		get_parent().add_child(missile5) #spawns a new missile

		fireSoundLoud.play()
		var missile6 = Missile.instance()
		missile6.position = position + Vector2(-30, 30).rotated(rotation)
		missile6.rotation = rotation - deg2rad(225)
		missile6.linear_velocity = Vector2(-missile_speed/2, missile_speed/2).rotated(rotation)
		get_parent().add_child(missile6) #spawns a new missile

		fireSoundLoud.play()
		var missile7 = Missile.instance()
		missile7.position = position + Vector2(30, -30).rotated(rotation)
		missile7.rotation = rotation - deg2rad(45)
		missile7.linear_velocity = Vector2(missile_speed/2, -missile_speed/2).rotated(rotation)
		get_parent().add_child(missile7) #spawns a new missile

		fireSoundLoud.play()
		var missile8 = Missile.instance()
		missile8.position = position + Vector2(-40, 25/2).rotated(rotation)
		missile8.rotation = rotation
		missile8.linear_velocity = Vector2(-missile_speed, 0).rotated(rotation)
		get_parent().add_child(missile8) #spawns a new missile

		fireSoundLoud.play()
		var missile9 = Missile.instance()
		missile9.position = position + Vector2(-40, -25/2).rotated(rotation)
		missile9.rotation = rotation
		missile9.linear_velocity = Vector2(-missile_speed, 0).rotated(rotation)
		get_parent().add_child(missile9) #spawns a new missile

		numCircles += 1
		if (numCircles == 3):
			numCircles = 0
			spawnMissileCircle = false

	if (not playingCreepySound && randi()%4000 == 0):
		creepy1.play()
		playingCreepySound = true
	elif (playingCreepySound):
		playingCreepySound = false

	#increase velocity when up arrow is pressed and play an animation
	if (not confused):
		if ((Input.is_action_pressed("ui_up") or overdrive) and not need_to_respawn):
			thrust = Vector2(acceleration, 0)
			thrusterSound.play()
			spriteShip.set_texture(shipFlame)
			spriteShip.set_scale(Vector2(.17,.21)) #width/length
		else:
			thrust = Vector2()
			spriteShip.set_texture(shipNoFlame)
			spriteShip.set_scale(Vector2(.4,.45))
	
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
			if (disableMissile and recharge_timer <= 0):
				gunJam.play()
				recharge_timer = recharge_time
			if (recharge_timer <= 0 and not need_to_respawn and not disableMissile):
	
				for offset in [Vector2(30, -25/2), Vector2(30, 25/2)]:
					fireSound.play()
					var missile = Missile.instance()
					missile.position = position + offset.rotated(rotation)
					missile.rotation = rotation
					missile.scoreMultiplier = scoreMultiplier
					missile.linear_velocity = Vector2(missile_speed, 0).rotated(rotation)
	
					if (missileDelay):
						missile.despawnTime = 10000 #missile do not despawn for 10 seconds
					get_parent().add_child(missile) #spawns a new missile
				recharge_timer = recharge_time
	else: #WE ARE CONFUSED
		if ((Input.is_action_pressed("ui_right") or overdrive) and not need_to_respawn):
			thrust = Vector2(acceleration, 0)
			thrusterSound.play()
			spriteShip.set_texture(shipFlame)
			spriteShip.set_scale(Vector2(.17,.21)) #width/length
		else:
			thrust = Vector2()
			spriteShip.set_texture(shipNoFlame)
			spriteShip.set_scale(Vector2(.4,.45))
	
		#set rotation direction when arrow keys are pressed
		if (Input.is_action_pressed("ui_accept")):
			rotation_dir = -1
		elif (Input.is_action_pressed("ui_up")):
			rotation_dir = 1
		else:
			rotation_dir = 0
	
		if (Input.is_action_pressed("P") and need_to_respawn):
			overrideSpawn = true
	
		#fire the gun
		if (Input.is_action_pressed("ui_left")):
			if (disableMissile and recharge_timer <= 0):
				gunJam.play()
				recharge_timer = recharge_time
			if (recharge_timer <= 0 and not need_to_respawn and not disableMissile):
	
				for offset in [Vector2(30, -25/2), Vector2(30, 25/2)]:
					fireSound.play()
					var missile = Missile.instance()
					missile.position = position + offset.rotated(rotation)
					missile.rotation = rotation
					missile.scoreMultiplier = scoreMultiplier
					missile.linear_velocity = Vector2(missile_speed, 0).rotated(rotation)
	
					if (missileDelay):
						missile.despawnTime = 10000 #missile do not despawn for 10 seconds
					get_parent().add_child(missile) #spawns a new missile
				recharge_timer = recharge_time

	recharge_timer -= delta

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

		if ("Asteroid" in str(contact.get_name())): #collided with an asteroid
			if contact.get_script().has_script_signal("explode"): #if the ship touches an asteroid

				contact.emit_signal("explode") #destroy the asteroid
				#grant points for destroying the asteroid with your ship
				if (contact.size == 2): #20 points for large
					ui.increase_score(20*scoreMultiplier)
				elif (contact.size == 1): #50 points for medium
					ui.increase_score(50*scoreMultiplier)
				elif (contact.size == 0): #100 points for small
					ui.increase_score(100*scoreMultiplier)

				ui.decrease_health() #lose a life
				shipExplosion.play()

				if (ui.get_health() >= 0): #the ship needs to be "respawned"
					need_to_respawn = true
					set_collision_layer_bit(1, 0)
					set_collision_mask_bit(0, 0)
					hide()
		else: #collided with a powerup
			if ("PowerupNoMissile" in str(contact.get_name())): #disable the cannon
				disableMissile = true
				gunJam.play()
				powerupGrabTimeDisableMissile = OS.get_ticks_msec()
			if ("PowerupExtraLife" in str(contact.get_name())): #grant an extra life
				ui.increase_health()
				extraShip.play()
			if ("PowerupRapidFire" in str(contact.get_name())): #increase canon fire rate
				rapidFire.play()
				recharge_time = .1
				powerupGrabTimeRapidFire = OS.get_ticks_msec()
				canonFireRateUp = true
			if ("PowerupMissileCircle" in str(contact.get_name())): #instant missile spawns all around the ship
				spawnMissileCircle = true
				powerupGrabTimeMissileCircle = OS.get_ticks_msec()
			if ("PowerupDelay" in str(contact.get_name())): #missiles don't despawn for a longer time
				missileDelay = true
				clock.play()
				powerupGrabTimeDelay = OS.get_ticks_msec()
			if ("PowerupScore" in str(contact.get_name())): #increase score
				extraScore = true
				scoreUp.play()
				scoreMultiplier = 5
				powerupGrabTimeScore = OS.get_ticks_msec()
			if ("PowerupLegendary" in str(contact.get_name())): #legendary powerup!
				ui.increase_health()

				extraShip.play()
				rapidFire.play()
				clock.play()
				scoreUp.play()

				recharge_time = .02
				canonFireRateUp = true
				spawnMissileCircle = true
				missileDelay = true
				extraScore = true
				extraSpin = true
				spin_thrust = 10
				scoreMultiplier = 2
				powerupGrabTimeLegendary = OS.get_ticks_msec()
				powerupGrabTimeScore = OS.get_ticks_msec()
				powerupGrabTimeDelay = OS.get_ticks_msec()
				powerupGrabTimeMissileCircle = OS.get_ticks_msec()
				powerupGrabTimeRapidFire = OS.get_ticks_msec()

			#Debuffs
			if ("PowerupFastRocks" in str(contact.get_name())): #speed up asteroids
				moveFaster.play()
				fastrocks = true
				powerupGrabTimeFastRocks = OS.get_ticks_msec()
				var asteroids = get_tree().current_scene.get_node("Level").get_children()
				for asteroid in asteroids:
					if asteroid.is_class("RigidBody2D"):
						asteroid.linear_velocity = asteroid.get_linear_velocity() * asteroid_speed_multiplier
			if ("PowerupInvisible" in str(contact.get_name())): #grant an extra life
				invis = true
				ivisibleSound.play()
				hide()
				powerupGrabTimeInvis = OS.get_ticks_msec()
			if ("PowerupLoseLife" in str(contact.get_name())): #grant an extra life
				ui.decrease_health()
				loseLife.play()
			if ("PowerupOverdrive" in str(contact.get_name())): #grant an extra life
				overdrive = true
				powerupGrabTimeOverdrive = OS.get_ticks_msec()
			if ("PowerupBadControls" in str(contact.get_name())): #confuse the controls
				confused = true
				confuseSound.play()
				powerupGrabTimeConfused = OS.get_ticks_msec()
			pass

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
