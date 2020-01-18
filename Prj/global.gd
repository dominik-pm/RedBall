extends Node

var level_count = 4
var current_level = 4

var level_path = "World/Levels/"
var testing = false

func _ready():
	if testing:
		change_scene("World/Test_Level")
	else:
		load_level(current_level)

func level_finished():
	if testing:
		load_level(current_level)
	else:
		if current_level < level_count:
			load_level(current_level+1)
		else:
			print("finished last level")

func load_level(lvl):
	change_scene(level_path+"Level_"+str(lvl))

func change_scene(path):
	get_tree().change_scene("res://"+str(path)+".tscn")
