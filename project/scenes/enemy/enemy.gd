
extends RigidBody2D

const TICK_MOVE = 0.5
const FORCE_MOVE_MAX = 1024
const FORCE_MOVE_MIN = 256

var timer = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timer+= delta
	if timer > TICK_MOVE:
		timer = 0
		
		var r = rand_range(-FORCE_MOVE_MAX, FORCE_MOVE_MAX) - rand_range(-FORCE_MOVE_MIN, FORCE_MOVE_MIN)
		var vel = Vector2(r, 0)
		set_linear_velocity(vel)

func _on_Area2D_body_enter( body ):
	if body == Globals.get("Player"):
		queue_free()
