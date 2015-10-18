
extends Area2D

const STOP_RATIO = 0.96

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if Globals.get("Player") in get_overlapping_bodies():
		var s = Globals.get("Player").get_linear_velocity()
		s.x *= STOP_RATIO# * delta
		Globals.get("Player").set_linear_velocity(s)
