
extends Node2D

var level_length = 0.0

func _ready():
	Globals.set("Level", self)

func add_item(item):
	return get_node("objects").add_child(item)
