extends Node2D

const G = 100

func _ready() -> void:
	pass 

func get_distance_between_objects(body1, body2):
	var radius = body1.global_position-body2.global_position # radius = distance
	radius = sqrt(radius.x*radius.x + radius.y*radius.y)
	return radius

func _physics_process(delta: float) -> void:
	calculate_gravity()
	
	$Tether.set_point_position(0, $MassObjects/Ship.position)
	$Tether.set_point_position(1, $MassObjects/Alien.position)

func calculate_gravity():
	for body1 in $MassObjects.get_children():
		var cum_grav_force = Vector2.ZERO # initialise cumulative gravity 
		for body2 in $MassObjects.get_children():
			if body1 != body2: # if not the same object
				
				var force
				
				if body2 is TileMap:
					var tiles = body2.get_used_cells(0)
					for tile in tiles:
						tile = tile*16 + Vector2i(8,8)
						tile = Vector2(tile)
						tile = tile*body2.scale + body2.global_position
						$TileToBody.mass = body2.mass
						$TileToBody.global_position = tile
						force = get_force(body1, $TileToBody)
						cum_grav_force += force
				else:
					force = get_force(body1, body2)
					# add gravity force of every object to every other object
					cum_grav_force += force
				
		body1.grav_force = cum_grav_force
		if body1.name == "Alien":
			print(cum_grav_force)

func get_force(body1, body2):
	var radius = get_distance_between_objects(body1, body2)
	var magnitude = (body1.mass*body2.mass)/(radius*radius)
	var angle = body1.get_angle_to(body2.global_position)
	var vertical = magnitude * sin(angle)
	var horizontal = magnitude * cos(angle)
	
	var force = Vector2(horizontal, vertical) * G # apply gravity force 
	
	# TEMPORARY - ADD MULTIPLIER FOR SHIP
	if body2.name == "Ship":
		force *= 5 # used to be 5
	
	return force
