extends Node2D

var AsteroidSmall = preload("res://asteroidClassic/AsteroidSmallClassic.tscn")
var AsteroidMedium = preload("res://asteroidClassic/AsteroidMediumClassic.tscn")
var AsteroidLarge = preload("res://asteroidClassic/AsteroidLargeClassic.tscn")

onready var ship = get_tree().current_scene.find_node("Ship")
onready var ui = get_tree().current_scene.find_node("UI")

export var level = -1
export var safeRadius = 250
export var minAsteroids = 5 #number of new asteroids to spawn for each level
export var maxSpeed = 100
export var minSpeed = 100

var currentAsteroidCount = 1
var extraLifeScore = 10000
var currentScore = 0
var extraLifeSound

func _process(delta):
	var count = 0 #check if there are any asteroids on-screen
	for node in get_children():
		if (node.is_class("RigidBody2D")):
			count += 1
			break
	
	if (count == 0): #if no asteroids on-screen, spawn more
		level += 1
		var avoid = ship.position
		var viewport = get_viewport().get_visible_rect().size
		
		for i in range(level + minAsteroids):
			var child
			#match randi() % 3: #randomly spawns an asteroid instance for each level
				#0: child = AsteroidSmall.instance()
				#1: child = AsteroidMedium.instance()
				#2: child = AsteroidLarge.instance()
			
			child = AsteroidLarge.instance()
				
			var where = avoid
			while (where - avoid).length() <= safeRadius: #spawns asteroids around the player, not near them
				where.x = rand_range(0, viewport.x)
				where.y = rand_range(0, viewport.y)
				pass
			child.position = where
			
			var angle = randi() * PI * 2
			var speed = rand_range(minSpeed, maxSpeed)
			child.linear_velocity = Vector2(speed, 0).rotated(angle)
			
			add_child(child)
			pass
		pass
		
	if (get_child_count() != currentAsteroidCount): #checks if an asteroid has been destroyed
		currentAsteroidCount = get_child_count()
		
		if (ui.get_score() - currentScore >= extraLifeScore): #grants an extra life for every 10,000 points
			currentScore += extraLifeScore
			ui.increase_health()
			var extraLifeSound = AudioStreamPlayer.new()
			self.add_child(extraLifeSound)
			extraLifeSound.stream = load("res://sounds/extraShip.wav")
			extraLifeSound.play()
		pass
	pass