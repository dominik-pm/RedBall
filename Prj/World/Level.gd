extends Node2D

var player
var last_checkpoint

func _ready():
	player = $Player
	last_checkpoint = $CheckPoints/Checkpoint1

func new_checkpoint(checkpoint):
	last_checkpoint = checkpoint

func died():
	player.position = last_checkpoint.position
	reset_obstacles()

func reset_obstacles():
	for child in get_children():
		if child.has_method('reset'):
			child.reset()
		elif child.get_child_count() > 0:
			for subchild in child.get_children():
				if subchild.has_method('reset'):
					subchild.reset()
				elif subchild.get_child_count() > 0:
					for subsubchild in subchild.get_children():
						if subsubchild.has_method('reset'):
							subsubchild.reset()
			
