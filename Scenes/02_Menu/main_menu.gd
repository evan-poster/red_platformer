extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://level1.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
