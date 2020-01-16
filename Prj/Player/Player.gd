extends KinematicBody2D

export var jump_force = 500
export var movement_speed = 15
export var max_speed = 150
export var gravity = 9.81
export var rotation_speed = 3
export var death_height = 1000

var velocity = Vector2(0,0)
var dir = 0

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		dir += movement_speed
	if Input.is_action_pressed("move_right"):
		dir -= movement_speed
	if Input.is_action_pressed("jump"):
		velocity.y -= jump_force
	
	dir = clamp(dir, -max_speed, max_speed)
	
	rotate(deg2rad(dir*delta*rotation_speed))
	
	if !is_on_floor():
		velocity.y += gravity
		if position.y > death_height:
			die()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func die():
	print("died!")
	
	# animation
	
	get_parent().died()
