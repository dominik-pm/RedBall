extends KinematicBody2D

export var jump_force = 500
export var movement_speed = 15
export var max_speed = 150
export var gravity = 9.81

var velocity = Vector2(0,0)
var dir = 0

func _physics_process(delta):
	
	if Input.is_action_pressed("move_left"):
		dir += movement_speed
	if Input.is_action_pressed("move_right"):
		dir -= movement_speed
	if Input.is_action_pressed("jump"):
		velocity.y -= jump_force
	
	dir = clamp()
	
	if !is_on_floor():
		velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
