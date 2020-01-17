extends Node2D

var player
var last_checkpoint

func _ready():
	player = $Player

func new_checkpoint(checkpoint):
	last_checkpoint = checkpoint

func level_finished():
	global.level_finished()

func died():
	player.position = last_checkpoint.position
