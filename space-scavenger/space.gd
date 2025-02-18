extends Node2D

const G = 100

func _ready() -> void:
	pass 

func get_distance_between_objects(body1, body2):
	var radius = body1.global_position-body2.global_position # radius = distance
	radius = sqrt(radius.x*radius.x + radius.y*radius.y)
	return radius

func _physics_process(delta: float) -> void:
	for body1 in $MassObjects.get_children():
		var cum_grav_force = Vector2.ZERO # initialise cumulative gravity 
		for body2 in $MassObjects.get_children():
			if body1 != body2: # if not the same object

				var radius = get_distance_between_objects(body1, body2)
				var magnitude = (body1.mass*body2.mass)/(radius*radius)
				var angle = body1.get_angle_to(body2.global_position)
				var vertical = magnitude * sin(angle)
				var horizontal = magnitude * cos(angle)
				
				var force = Vector2(horizontal, vertical) * G # apply gravity force 
				
				# TEMPORARY - ADD MULTIPLIER FOR SHIP
				if body2.name == "Ship":
					force *= 5 # used to be 5
					
				# add gravity force of every object to every other object
				cum_grav_force += force
				
		body1.grav_force = cum_grav_force
