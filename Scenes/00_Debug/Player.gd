extends CharacterBody2D

"""
	Update player state based on user input and physics
	
	1. Determine player intent via input
	2. Determine player object state
	3. Apply state based on intent within context of physics

"""

enum PlayerState {
	IDLE,
	RUN,
	JUMPING,
	FALLING,
}

var last_state
var state = PlayerState.IDLE
var weapon_drawn = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	last_state = state
	state = PlayerState.IDLE

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			state = PlayerState.FALLING
		else:
			state = PlayerState.JUMPING

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state = PlayerState.JUMPING

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
		# Set player sprite direction based on direction pos/neg value
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true
		if is_on_floor():
			if direction == 0:
				state = PlayerState.IDLE
			else:
				state = PlayerState.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply physics
	move_and_slide()

	# Process based on state
	match state:
		PlayerState.IDLE:
			if state != last_state:
				$AnimatedSprite2D.play("idle")
		PlayerState.RUN:
			if state != last_state:
				$AnimatedSprite2D.play("run")
		PlayerState.JUMPING:
			if state != last_state:
				$AnimatedSprite2D.play("jump")
		PlayerState.FALLING:
			if state != last_state:
				$AnimatedSprite2D.play("fall")