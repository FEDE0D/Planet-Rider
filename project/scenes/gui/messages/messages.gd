
extends Control

var gas_low = 0

func _ready():
	Globals.set("GUI/Messages", self)

func show_gas_low(show):
	if show and not get_node("gas_low/AnimationPlayer").is_playing() and gas_low < 1:
		get_node("gas_low/AnimationPlayer").play("show")
		gas_low += 1
	elif not show:
		get_node("gas_low/AnimationPlayer").stop()
