
extends RigidBody2D

var FORCE_SPEED = 2048.0
var FORCE_SPEED_MULTIPLIER = 1
const FORCE_TURN = 128.0
const FORCE_JUMP = 1024.0
const STOP_RATIO = 0.2
const POWER_UP_SECS = 4.0
const GAS_USAGE_SEC = 1/30.0

var ended = false
var win = false

var direction = 1
var powerup = 0.0
var gas_tank = 1.0

func _ready():
	Globals.set("Player", self)
	set_fixed_process(true)
	set_process_input(true)
	get_node("RayCast2D").add_exception(self)
	get_node("RayCast2D").add_exception(get_node("hover"))

func _input(event):
	if event.is_action_pressed("jump") and not event.is_echo():
		if get_node("RayCast2D").is_colliding():
			jump()
	
	if event.is_action_pressed("ui_left") and not event.is_echo() and direction > 0:
		direction = -1
		get_node("AnimationPlayer").play("left")
	elif event.is_action_pressed("ui_right") and not event.is_echo() and direction < 0:
		direction = 1
		get_node("AnimationPlayer").play("right")

func _fixed_process(delta):
	if not ended:
		do_powerup(delta)
		do_move(delta)
	else:
		stop(delta)

func do_move(delta):
	if get_node("RayCast2D").is_colliding():
		var dir = Vector2(1, 0).rotated(get_rot())
		var speed_dir = 0
		if Input.is_action_pressed("speed_up"):
			speed_dir = 1
		elif Input.is_action_pressed("speed_down"):
			speed_dir = -1
		
		var impulse = Vector2(direction*speed_dir, 0) * dir * FORCE_SPEED * FORCE_SPEED_MULTIPLIER * delta
		apply_impulse(Vector2(), impulse)
		get_node("hover").apply_impulse(Vector2(), impulse)
		get_node("hover1").apply_impulse(Vector2(), impulse)
		
		# update gas tank
		if impulse != Vector2():
			gas_tank = max(0, gas_tank - (GAS_USAGE_SEC * delta))
			Globals.get("GUI").set_gas_porcentage(gas_tank)
			if gas_tank == 0:
				do_end()
		
	# turn
	var f = Vector2()
	if Input.is_action_pressed("ui_left"):
		f.x = -1
	elif Input.is_action_pressed("ui_right"):
		f.x = 1
	
	var av = get_angular_velocity()
	av += f.x * FORCE_TURN
	set_angular_velocity(av * delta)

func do_powerup(delta):
	if powerup > 0:
		FORCE_SPEED_MULTIPLIER = 3
		
		powerup -= delta
		if powerup <= 0:
			FORCE_SPEED_MULTIPLIER = 1

func jump():
	var vel = get_linear_velocity()
	set_linear_velocity(Vector2(vel.x, -FORCE_JUMP))
	get_node("hover").set_linear_velocity(Vector2(vel.x, -FORCE_JUMP))
	get_node("hover1").set_linear_velocity(Vector2(vel.x, -FORCE_JUMP))

func slow_down():
	var vel = get_linear_velocity() * STOP_RATIO
	set_linear_velocity(vel)
	get_node("hover").set_linear_velocity(vel)
	get_node("hover1").set_linear_velocity(vel)

func stop(delta):
	var vel = get_linear_velocity() * 0.97
	set_linear_velocity(vel)
	get_node("hover").set_linear_velocity(vel)
	get_node("hover1").set_linear_velocity(vel)

func powerup():
	powerup = POWER_UP_SECS

func do_win():
	win = true
	do_end()

func do_end():
	ended = true
	set_process_input(false)
