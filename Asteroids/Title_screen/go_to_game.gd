extends Control

func _ready():
	OS.set_window_maximized(true)

func _on_Classic_Asteroids_pressed():
	get_tree().change_scene('res://AsteroidsClassicClassic.tscn')
	
func _on_Asteroids_Twist_pressed():
	get_tree().change_scene('res://AsteroidsVariant.tscn')

func _on_Credits_pressed():
	get_tree().change_scene('res://Title_screen/Buttons/Credits_page.tscn')
	
func _on_return_to_title_pressed():
	get_tree().change_scene('res://Title_screen/Title.tscn')

func _on_return_title_pressed():
	get_tree().change_scene('res://Title_screen/Title.tscn')
