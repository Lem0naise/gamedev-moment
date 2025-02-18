extends Node2D

const G = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body1 in $MassObjects.get_children():
		for body2 in $MassObjects.get_children():
			if body1 != body2:
				var radius = body1.global_position-body2.global_position
				radius = sqrt(radius.x*radius.x + radius.y*radius.y)
				var magnitude = (body1.mass*body2.mass)/(radius*radius)
				var angle = body1.get_angle_to(body2.global_position)
				var vertical = magnitude * sin(angle)
				var horizontal = magnitude * cos(angle)
				var force = Vector2(horizontal, vertical) * G
				if body2.name == "Ship":
					force *= 5
				body1.grav_force = force
