extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if user wants to quit
	# if Input.is_action_just_pressed("ui_cancel"):
	# 	get_tree().quit()

	# Toggle Puase if user presses escape
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		# Toggle visibility of pause menu
		$Pause.visible = get_tree().paused
	# Quit game if 'q' is pressed
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()