extends CharacterBody2D

"""
	Update player current_state based on user input and physics
	
	1. Determine player intent via input
	2. Determine player object current_state
	3. Apply current_state based on intent within context of physics

"""

# State priority: Floor > Wall > AIR

enum State {
	FLOOR,
	AIR,
	WALL,
}

# State/Flag Variables
var last_state
var current_state = State.AIR
# var weapon_drawn = false

# Physics Parameters
const RUN_SPEED = 425.0
const JUMP_VELOCITY = -800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	# Track last state held by player
	last_state = current_state
	
	# Handle current_state
	match current_state:
		State.FLOOR:
			print("Current State: FLOOR")
			process_floor(delta)
		State.AIR:
			print("Current State: AIR")
			process_air(delta)
		State.WALL:
			print("Current State: WALL")
			process_wall(delta)

	# Apply physics
	move_and_slide()

#
# State Processing Functions
#

func process_floor(delta):
	# Confirm we're still on the ground
	if is_on_floor():
		# Jump interrupts running/idle
		if Input.is_action_just_pressed("player_jump"):
			velocity.y = JUMP_VELOCITY * 0.80
			current_state = State.AIR
		
		# Move left/right regardless
		move_left_right()

		# Update sprite
		if self.velocity.x != 0:
			if $AnimatedSprite2D.animation != "run":
				$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")

	else:
		current_state = State.AIR


func process_wall(_delta):
	# Check if we are against a wall
	if is_on_wall():
		pass


func process_air(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		move_left_right()
		
		# Ensure we are using 'jump' or 'fall' based on velocity.y
		if velocity.y < 0:
			if $AnimatedSprite2D.animation != "jump":
				$AnimatedSprite2D.play("jump")
		else:
			if $AnimatedSprite2D.animation != "fall":
				$AnimatedSprite2D.play("fall")
		# Ensure our sprite is facing the correct way
		$AnimatedSprite2D.flip_h = velocity.x < 0

	else:
		current_state = State.FLOOR


#
# Helper functions
#

func move_left_right():
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * RUN_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED)

