extends KinematicBody2D

var death_particles = preload("res://Player/Death_Particles.tscn")

export var finish_level_duration = 2

export var jump_force = 380
export var jump_hold_boost = 400
export var jump_hold_boost_duration = 100
export var jump_bounce_boost = 50
export var movement_speed = 11
export var max_speed = 450
export var gravity = 18
export var rotation_speed = 2
export var death_height = 1000
export var damp = 0.99

var velocity = Vector2(0,0)
var dir = 0
var level_finished = false
var jumpcount = 0
var dying = false
var jump_hold = false
var can_bounce = true

onready var level = $"../"

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _physics_process(delta):
	if !level_finished:
		if Input.is_action_pressed("move_left"):
			dir -= movement_speed
		if Input.is_action_pressed("move_right"):
			dir += movement_speed
		
		if jump_hold and Input.is_action_pressed("jump") and !is_on_floor() and jumpcount < jump_hold_boost_duration:
			jumpcount += 1
			velocity.y -= jump_hold_boost*delta
		else:
			jump_hold = false
		
		if Input.is_action_pressed("jump") and is_on_floor():
			if can_bounce:
				velocity.y -= jump_bounce_boost
			velocity.y -= jump_force
			jumpcount = 0
			jump_hold = true
		
		if Input.is_action_pressed("jump"):
			can_bounce = true
		else:
			can_bounce = false
	
	dir = clamp(dir, -max_speed, max_speed)
	dir = dir*damp
	
	velocity.x = dir
	
	rotate(deg2rad(dir*delta*rotation_speed))
	
	if !is_on_floor():
		velocity.y += gravity
		if position.y > death_height:
			die()
	
	if !level_finished:
		velocity = move_and_slide(velocity, Vector2(0, -1))
	else:
		velocity = move_and_slide(velocity*damp, Vector2(0, -1))

func get_checkpoint(checkpoint):
	level.new_checkpoint(checkpoint)

func level_finished():
	level_finished = true
	damp = damp*0.96
	
	yield(get_tree().create_timer(finish_level_duration), "timeout")
	global.level_finished()

func die():
	if !level_finished and !dying:
		dying = true
		set_physics_process(false)
		
		var dp = death_particles.instance()
		get_tree().root.add_child(dp)
		dp.position = self.position
		dp.emitting = true
		
		$player.visible = false
		
		yield(get_tree().create_timer(dp.lifetime), "timeout")
		
		set_physics_process(true)
		velocity = Vector2(0,0)
		dir = 0
		dp.queue_free()
		$player.visible = true
		
		level.died()
		dying = false
