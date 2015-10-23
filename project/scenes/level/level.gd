
extends Node2D

var level_length = 0.0
export(Color) var color_max = Color("341313")

func _ready():
	Globals.set("Level", self)
	set_process_input(true)
	get_node("CanvasModulate").set_color(color_max.linear_interpolate(Color("ffffff"), randf()))

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func add_item(item):
	return get_node("objects").add_child(item)