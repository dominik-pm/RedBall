extends KinematicBody2D

var death_particles = preload("res://Player/Death_Particles.tscn")

export var jump_force = 450
export var movement_speed = 11
export var max_speed = 390
export var gravity = 11
export var rotation_speed = 2
export var death_height = 1000
export var damp = 0.99

var velocity = Vector2(0,0)
var dir = 0

onready var level = $"../"

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

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
	
	var dp = death_particles.instance()
	get_tree().root.add_child(dp)
	dp.position = self.position
	#$player.visible = false
	
	yield(get_tree().create_timer(dp.lifetime), "timeout")
	
	set_physics_process(true)
	dp.queue_free()
	$player.visible = true
	
	level.died()
