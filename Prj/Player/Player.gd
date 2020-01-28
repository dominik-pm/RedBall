extends KinematicBody2D

var death_particles = preload("res://Player/Death_Particles.tscn")

export var finish_level_duration = 1.8

export var jump_force = 370
export var jump_hold_boost = 420
export var jump_hold_boost_duration = 100
export var jump_bounce_boost = 50
export var movement_speed = 15
export var max_speed = 550
export var gravity = 18
export var rotation_speed = 2
export var death_height = 1000
export var level_finished_damp = 0.99
export var rotation_fade_speed = 0.1

const UP = Vector2(0, -1)
var velocity = Vector2(0,0)
var dir = 0
var level_finished = false
var jumpcount = 0
var is_grounded = false
var dying = false
var is_jumping = false
var jump_hold = false
var can_bounce = true
var actual_rotation_speed = 0

onready var level = $"../"
onready var ray = $FloorRay
onready var sprite = $player

func reset():
	velocity = Vector2(0,0)
	dir = 0

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("restart"):
		if not dying:
			level.restart()

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
		
		if is_on_floor() and velocity.y >= 0:
			is_jumping = false
		
		if ray.get_collider() != null:
			is_grounded = true
		else:
			is_grounded = false
	
		
		if Input.is_action_pressed("jump") and is_grounded and not is_jumping:
			if can_bounce:
				velocity.y -= jump_bounce_boost 
			velocity.y -= jump_force
			jumpcount = 0
			jump_hold = true
			is_jumping = true

		if Input.is_action_pressed("jump"):
			can_bounce = true
		else:
			can_bounce = false
	
	dir = clamp(dir, -max_speed, max_speed)
	dir = dir*level_finished_damp
	if abs(dir) < movement_speed/2:
		dir = 0
	
	velocity.x = dir
	
	if is_grounded:
		sprite.rotate(deg2rad(dir*delta*rotation_speed))
		actual_rotation_speed = dir*delta*rotation_speed
	else:
		sprite.rotate(deg2rad(actual_rotation_speed))
		if actual_rotation_speed >= 0:
			actual_rotation_speed -= rotation_fade_speed
		else:
			actual_rotation_speed += rotation_fade_speed
	
	if !is_on_floor():
		velocity.y += gravity
		if position.y > death_height:
			die()
	
	var snap = Vector2.DOWN * 16 if !is_jumping else Vector2.ZERO
	
	if !level_finished:
		velocity = move_and_slide(velocity, UP)
		#velocity = move_and_slide_with_snap(velocity, snap, UP, false)
	else:
		velocity = move_and_slide(velocity*level_finished_damp, UP)
		#velocity = move_and_slide_with_snap(velocity*level_finished_damp, snap, UP, true)
	
	if abs(velocity.x) < 0.5:
		dir = 0

func get_checkpoint(checkpoint):
	level.new_checkpoint(checkpoint)

func finish():
	level_finished = true
	level_finished_damp = level_finished_damp*0.96
	
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
		dp.queue_free()
		$player.visible = true
		
		level.died()
		dying = false
