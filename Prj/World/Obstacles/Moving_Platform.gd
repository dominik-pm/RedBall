extends Node2D

export (NodePath) var move_to
export var moving_speed = 3.0
const IDLE_DURATION = 0.5

onready var tween = $MoveTween
onready var platform = $Platform

var follow = Vector2.ZERO
var dir = 1
var start_pos
var end_pos
var move_up = false

func _ready():
	move_to = get_node(move_to).position-position
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(moving_speed * global.UNIT_SIZE)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION*2)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
