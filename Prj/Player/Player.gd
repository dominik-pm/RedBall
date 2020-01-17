extends KinematicBody2D

export var jump_force = 750
export var movement_speed = 20
export var max_speed = 200
export var gravity = 20
export var rotation_speed = 3
export var death_height = 1000
export var damp = 0.98

var velocity = Vector2(0,0)
var dir = 0

onready var level = $"../"

export var death_duration = 2

func _ready():
	$Particles2D.lifetime = death_duration

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		dir -= movement_speed
	if Input.is_action_pressed("move_right"):
		dir += movement_speed
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
	
	dir = clamp(dir, -max_speed, max_speed)
	dir = dir*damp
	
	velocity.x = dir
	
	rotate(deg2rad(dir*delta*rotation_speed))
	
	if !is_on_floor():
		velocity.y += gravity
		if position.y > death_height:
			die()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func get_checkpoint(checkpoint):
	level.new_checkpoint(checkpoint)

func level_finished():
	level.level_finished()

func die():
	set_physics_process(false)
	$Particles2D.emitting = true
	$player.visible = false
	
	yield(get_tree().create_timer(death_duration), "timeout")
	
	$Particles2D.emitting = false
	$player.visible = true
	
	level.died()
