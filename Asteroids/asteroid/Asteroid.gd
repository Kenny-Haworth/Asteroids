extends "res://weightless/Weightless.gd"

var AsteroidSmall = preload("res://asteroid/AsteroidSmall.tscn")
var AsteroidMedium = preload("res://asteroid/AsteroidMedium.tscn")

#Buffs
var PowerupExtraLife = preload("res://powerups/PowerupExtraLife.tscn")
var PowerupRapidFire = preload("res://powerups/PowerupRapidFire.tscn")
var PowerupMissileCircle = preload("res://powerups/PowerupMissileCircle.tscn")

var PowerupDelay = preload("res://powerups/PowerupDelay.tscn")
var PowerupScore = preload("res://powerups/PowerupScore.tscn")
var PowerupLegendary = preload("res://powerups/PowerupLegendary.tscn")

#Debuffs
var PowerupNoMissile = preload("res://powerups/PowerupNoMissile.tscn")
var PowerupInvisible = preload("res://powerups/PowerupInvisible.tscn")
var PowerupAsteroids = preload("res://powerups/PowerupAsteroids.tscn")
var PowerupLoseLife = preload("res://powerups/PowerupLoseLife.tscn")
var PowerupOverdrive = preload("res://powerups/PowerupOverdrive.tscn")
var PowerupBadControls = preload("res://powerups/PowerupBadControls.tscn")

export(float) var explode_force #for powerups ONLY
var despawnTime = 1000 #1 second to play a sound
var currentTime
var despawn = false

signal explode

enum Size {
	SMALL, MEDIUM, LARGE
}

export(Size) var size = Size.LARGE
var radius

func _ready():
	connect("explode", self, "_explode")
	radius = get_node("Sprite").texture.get_width() / 2 * get_node("Sprite").scale

func _process(delta):
	if (despawn and OS.get_ticks_msec() >= currentTime + despawnTime):
		queue_free()
	pass

func _explode():

	var objects = get_tree().current_scene.get_node("Level").get_children()

	if size != Size.SMALL:
		for i in range(0, 2): #number of asteroids to spawn when one blows up
			var offset_dir = PI * 2 / 3 * i
			var asteroid
			var spawnPowerup = false
			match size:
				MEDIUM: #medium blows up, spawn a small
					bangMedium.play()
					asteroid = AsteroidSmall.instance()

					if (randi()%20+1 == 1): #5% chance to spawn powerup from medium asteroid
						spawnPowerup = true

				LARGE: #large blows up, spawn a medium
					bangLarge.play()
					asteroid = AsteroidMedium.instance()

					if (randi()%100+1 <= 15): #15% chance to spawn powerup from large asteroid
						spawnPowerup = true

			if spawnPowerup:

				var powerupType = randi()%2+1
				var powerup

				if (powerupType == 1): #spawn a good powerup
					powerupType = randi()%11+1

					if (powerupType == 1 or powerupType == 2):
						powerup = PowerupExtraLife.instance()
						powerup.set_name("PowerupExtraLife")
					elif (powerupType == 3 or powerupType == 4):
						powerup = PowerupRapidFire.instance()
						powerup.set_name("PowerupRapidFire")
					elif (powerupType == 5 or powerupType == 6):
						powerup = PowerupMissileCircle.instance()
						powerup.set_name("PowerupMissileCircle")
					elif (powerupType == 7 or powerupType == 8):
						powerup = PowerupDelay.instance()
						powerup.set_name("PowerupDelay")
					elif (powerupType == 9 or powerupType == 10):
						powerup = PowerupScore.instance()
						powerup.set_name("PowerupScore")
					elif (powerupType == 11):
						powerup = PowerupLegendary.instance()
						powerup.set_name("PowerupLegendary")
						
					explode_force = randi()%50+100 #100-150

				else: #spawn a bad powerup
					powerupType = randi()%6+1 #1-6

					if (powerupType == 1):
						powerup = PowerupNoMissile.instance()
						powerup.set_name("PowerupNoMissile")
					elif (powerupType == 2):
						powerup = PowerupInvisible.instance()
						powerup.set_name("PowerupInvisible")
					elif (powerupType == 3):
						powerup = PowerupAsteroids.instance()
						powerup.set_name("PowerupFastRocks")
					elif (powerupType == 4):
						powerup = PowerupLoseLife.instance()
						powerup.set_name("PowerupLoseLife")
					elif (powerupType == 5):
						powerup = PowerupOverdrive.instance()
						powerup.set_name("PowerupOverdrive")
					elif (powerupType == 6):
						powerup = PowerupBadControls.instance()
						powerup.set_name("PowerupBadControls")
					
					explode_force = randi()%50+150 #150-200, debuffs fly faster

				powerup.position = position + radius.rotated(offset_dir)
				powerup.linear_velocity = linear_velocity + Vector2(explode_force, 0).rotated(offset_dir)

				get_parent().add_child(powerup)
				spawnPowerup = false

			asteroid.position = position + radius.rotated(offset_dir)
			asteroid.linear_velocity = linear_velocity + Vector2(0, 0).rotated(offset_dir)
			get_parent().add_child(asteroid)
	else:
		bangSmall.play()
	despawn = true
	currentTime = OS.get_ticks_msec()
	set_collision_layer_bit(0, 0)
	set_collision_mask_bit(1, 0)
	set_collision_mask_bit(2, 0)
	hide()
	sleeping = true
	pass
