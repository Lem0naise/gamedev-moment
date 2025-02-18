extends CharacterBody2D
#hello

const SPEED = 300.0
const JUMP_VELOCITY = -200.0 #Not used rn
const mass = 80
var grav_force = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not (is_on_something()):
		velocity -= grav_force * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_h := Input.get_axis("left", "right")
	var direction_v := Input.get_axis("up", "down")
	if direction_h and is_on_something():
		velocity.x = direction_h * SPEED
	elif direction_v and is_on_something():
		velocity.y = direction_v * SPEED
	elif is_on_something():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func is_on_something():
	return (is_on_floor() || is_on_ceiling() || is_on_wall())
