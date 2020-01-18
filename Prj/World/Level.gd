extends Node2D

var player = preload("res://Player/Player.tscn")

func _ready():
	flag_checkpoints()
	
	player = player.instance()
	add_child(player)
	player.position = get_checkpoint(global.current_checkpoint).position

func restart():
	global.restart_level()

func died():
	restart()

func new_checkpoint(cp):
	global.current_checkpoint = get_checkpoint_index(cp)

func flag_checkpoints():
	for i in range(0, global.current_checkpoint+1):
		$CheckPoints.get_child(i).flag()

func get_checkpoint(index : int):
	var checkpoints = $CheckPoints.get_children()
	return checkpoints[index]

func get_checkpoint_index(checkpoint):
	var all = $CheckPoints.get_children()
	for i in range(0, all.size()):
		if all[i] == checkpoint:
			return i
	print("new checkpoint not found")
	return 0
