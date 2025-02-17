extends CharacterBody2D
#hello

const SPEED = 300.0
const JUMP_VELOCITY = -200.0
const mass = 80
var grav_force = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity -= grav_force * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and is_on_floor():
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
