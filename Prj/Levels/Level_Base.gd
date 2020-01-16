extends Node2D

var p = preload("res://Player/Player.tscn")
var player
var last_checkpoint

func _ready():
	player = p.instance()
	add_child(player)
	last_checkpoint = $Start
	
	player.position = last_checkpoint.position

func new_checkpoint(checkpoint):
	last_checkpoint = checkpoint

func died():
	player.position = last_checkpoint.position
