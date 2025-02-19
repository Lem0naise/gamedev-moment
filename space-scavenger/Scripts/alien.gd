extends CharacterBody2D
#hello

const SPEED = 300.0
const ROTATION_SPEED = 5
const JUMP_SPEED = 400.0
const JUMP_VELOCITY = -200.0 #Not used rn
const mass = 80
var grav_force = Vector2(0, 0)

func _ready():
	$Camera2D.ignore_rotation = false  # turn off Camera2D 'ignore rotation'
	
func _align_camera() -> void:
	$Camera2D.rotation = $Skin.rotation;
	
func get_down(gravity):
	return gravity.angle() - 1.5708
	
func _physics_process(delta: float) -> void:
	
	_align_camera()
	
	# Add the gravity.
	var collision = get_slide_collision(0)
	if not (is_on_something()):
		velocity += grav_force * delta
		# Rotate towards 'downwards' gravity
		$Skin.rotation = get_down(grav_force)
	elif collision:
		var normal = collision.get_normal()
		if normal.x < 0:
			$Skin.rotation_degrees = -90
		elif normal.x > 0:
			$Skin.rotation_degrees = 90
		elif normal.y < 0:
			$Skin.rotation_degrees = 0
		else:
			$Skin.rotation_degrees = 180
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_h := Input.get_axis("left", "right")
	var direction_v := Input.get_axis("up", "down")
	if direction_h and is_on_something():
		velocity = Vector2(0, 0)
		velocity.x = direction_h * SPEED
		velocity = velocity.rotated($Skin.rotation)
		# There is a problem where the player shakes when
		# moving on the bottom side of the ship
	if direction_v<0 and is_on_something():
		velocity.y = direction_v * JUMP_SPEED
		velocity = velocity.rotated(get_down(grav_force))
	if !direction_h && !direction_v && is_on_something():
		velocity.x = move_toward(velocity.x, 0.001, SPEED)
		velocity.y = move_toward(velocity.y, 0.001, SPEED)
	
	move_and_slide()
	
	
	_check_ship_visibility()
	
func is_on_something():
	return (is_on_floor() || is_on_ceiling() || is_on_wall())
		
func _check_ship_visibility() -> void:
	if not _is_ship_visible():
		$Arrow.show()
		$Arrow.rotation = get_down(self.position - $'../Ship'.position)
		
		var arrow_size = (self.position - $'../Ship'.position).length()
		arrow_size = remap(arrow_size, 1, 2000, 10, 1)
		$Arrow.scale = Vector2(arrow_size, arrow_size)
	else:
		$Arrow.hide()
	
	
func _is_ship_visible() -> bool:
	var overlapping_bodies = $Camera2D/VisibleArea.get_overlapping_bodies()
	if not overlapping_bodies: return false
	var bodies_names = []
	for body in overlapping_bodies:
		bodies_names.append(body.name)
	if bodies_names and 'Ship' in bodies_names:
		return true
	else:
		return false

	
