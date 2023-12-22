extends CharacterBody2D


@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -300.0

# ref of our animated sprited
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
	
func is_on_air():
	return not is_on_floor()
	

func player_state(delta):
	# Apply gravity to player while in the air
	if is_on_air():
		velocity.y += gravity * delta

func jump_handler():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		anim.play("jump_start")
		
func run_handler():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	# Incase animation is "jumpend", stop player movement
	if direction.x:
		velocity.x = direction.x * SPEED
		if velocity.y == 0:
			anim.play("run")
			
func idle_handler():
	if not direction.x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("idle")
		

func facing_direction_handler():
	if direction.x > 0:
		anim.flip_h = false
	elif direction.x < 0:
		anim.flip_h = true

func falling_handler():
	if velocity.y > 0 and is_on_air():
		anim.play("jump_end")
		
func player_controller():
	idle_handler()
	run_handler()
	jump_handler()
	facing_direction_handler()
	falling_handler()
	# For player to move on other collision obj
	move_and_slide()


# Entry Function, Called during the physics processing 
func _physics_process(delta):
	# Handle player on_air and on_floor states
	player_state(delta)
	
	# Control player action
	player_controller()
