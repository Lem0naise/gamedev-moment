extends CharacterBody2D

#Ok we're gonna need to make a tether so heres my idea.
#I was researching ropes in godot and they're awful but
#we could just create a loose ropey effect via animations
#when really the tether is a straight line. The sprite can
#be one short thing that tiles a long thin rectangle maybe

#oh might also mean arrow isnt necessary

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
		$Skin.rotation = normal.angle() + 0.5 * PI
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_h := Input.get_axis("left", "right")
	var direction_v := Input.get_axis("up", "down")
	var h_velocity = Vector2(0, 0)
	if direction_h and is_on_something():
		velocity = Vector2(0, 0)
		velocity.x = direction_h * SPEED
		velocity = velocity.rotated($Skin.rotation)
		h_velocity = velocity
		# There is a problem where the player shakes when
		# moving on the bottom side of the ship
	if direction_v<0 and is_on_something():
		velocity = Vector2(0, 0)
		var mag = sqrt(h_velocity.x**2 + h_velocity.y**2)
		velocity.y = -1* sqrt(abs(JUMP_SPEED**2 - mag**2))
		#velocity = velocity.rotated(get_down(grav_force))
		velocity = velocity.rotated($Skin.rotation)
		velocity += h_velocity
	if !direction_h && !direction_v && is_on_something():
		velocity.x = move_toward(velocity.x, 0.001, SPEED)
		velocity.y = move_toward(velocity.y, 0.001, SPEED)
	
	if Input.is_action_just_pressed("down"):
		var vector = Vector2($'../Ship'.global_position - global_position)
		var larger = vector.y
		if abs(vector.x) > abs(vector.y):
			larger = vector.x
		vector = vector / Vector2(abs(larger), abs(larger))
		vector *= Vector2(500, 500)
		velocity = vector
	
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
