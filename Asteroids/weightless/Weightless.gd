#this class wraps the screen so anything passing the viewport will appear on the other side
#anything that inherits from this class need not invoke this method, unless they override it,
#in which case this superclass method must be explicity invoked

extends RigidBody2D

onready var sprite = get_node("Sprite")
onready var viewport = get_viewport().get_visible_rect().size

var bangLarge
var bangMedium
var bangSmall

func _init():
	
	bangLarge = AudioStreamPlayer.new()
	self.add_child(bangLarge)
	bangLarge.stream = load("res://sounds/largeSound.wav")
	bangLarge.volume_db = -20
	
	bangMedium = AudioStreamPlayer.new()
	self.add_child(bangMedium)
	bangMedium.stream = load("res://sounds/mediumSound.wav")
	bangMedium.volume_db = -20
	
	bangSmall = AudioStreamPlayer.new()
	self.add_child(bangSmall)
	bangSmall.stream = load("res://sounds/smallSound.wav")
	bangSmall.volume_db = -20
	
	pass

func _integrate_forces(state):
	var size = sprite.texture.get_size() * sprite.scale
	var trans = state.get_transform()
	if (trans.origin.x < -size.x/2):
		trans.origin.x += viewport.x + size.x
	elif (trans.origin.x > viewport.x + size.x/2):
		trans.origin.x -= viewport.x + size.x
	elif (trans.origin.y < -size.y/2):
		trans.origin.y += viewport.y + size.y
	elif (trans.origin.y > viewport.y + size.y/2):
		trans.origin.y -= viewport.y + size.y

	state.set_transform(trans)
	pass
