extends Node

<<<<<<< HEAD
var level_count = 4
var current_level = 6
const UNIT_SIZE = 64
=======
var level_count = 6
var current_level = 1
const UNIT_SIZE = 16
>>>>>>> 65216d2377ec3f7d4617b3e21c075e55ebbe4238

var current_checkpoint = 0

var level_path = "World/Levels/"
var testing = false

func _ready():
	if testing:
		change_scene("World/Test_Level")
	else:
		load_level(current_level)

func restart_level():
	load_level(current_level)

func level_finished():
	if testing:
		current_level -= 1
	
	if current_level < level_count:
		current_level += 1
		current_checkpoint = 0
		load_level(current_level)
	else:
		print("finished last level")

func load_level(lvl):
	change_scene(level_path+"Level_"+str(lvl))

func change_scene(path):
	get_tree().change_scene("res://"+str(path)+".tscn")
