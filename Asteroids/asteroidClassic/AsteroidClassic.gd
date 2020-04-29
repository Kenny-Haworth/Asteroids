extends "res://weightlessClassic/Weightless.gd"

var AsteroidSmall = preload("res://asteroidClassic/AsteroidSmallClassic.tscn")
var AsteroidMedium = preload("res://asteroidClassic/AsteroidMediumClassic.tscn")

var AsteroidSmallOne = preload("res://asteroidClassic/AsteroidSmallOneClassic.tscn")
var AsteroidMediumOne = preload("res://asteroidClassic/AsteroidMediumOneClassic.tscn")

var AsteroidSmallTwo = preload("res://asteroidClassic/AsteroidSmallTwoClassic.tscn")
var AsteroidMediumTwo = preload("res://asteroidClassic/AsteroidMediumTwoClassic.tscn")

export(float) var explode_force = 0
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
	if size != Size.SMALL:
		for i in range(0, 2): #number of asteroids to spawn when one blows up
			var offset_dir = PI * 2 / 3 * i
			var asteroid
			match size:
				MEDIUM: #medium blows up, spawn a small
					bangMedium.play()
					match randi() % 3: #randomly spawn a smaller asteroid
						0: asteroid = AsteroidSmall.instance()
						1: asteroid = AsteroidSmallOne.instance()
						2: asteroid = AsteroidSmallTwo.instance()
				LARGE: #large blows up, spawn a medium
					bangLarge.play()
					match randi() % 3: #randomly spawn a smaller asteroid
						0: asteroid = AsteroidMedium.instance()
						1: asteroid = AsteroidMediumOne.instance()
						2: asteroid = AsteroidMediumTwo.instance()
			asteroid.position = position + radius.rotated(offset_dir)
			asteroid.linear_velocity = linear_velocity + Vector2(explode_force, 0).rotated(offset_dir)
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