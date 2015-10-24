
extends RigidBody2D

var FORCE_SPEED = 2500.0#2048.0
var FORCE_SPEED_MULTIPLIER = 1
const FORCE_TURN = 128.0
const FORCE_JUMP = 1024.0
const STOP_RATIO = 0.2
const POWER_UP_SECS = 4.0
const GAS_USAGE_SEC = 1/30.0
const SPEED_MAX_X = 1366.0

var ended = false
var win = false
var engine_breaks = 0

var direction = 1
var powerup = 0.0
var gas_tank = 1.0 setget set_gas_tank
func set_gas_tank(g):
	gas_tank = g
	Globals.get("GUI").set_gas_porcentage(gas_tank)

func _ready():
	Globals.set("Player", self)
	set_fixed_process(true)
	set_process_input(true)
	get_node("RayCast2D").add_exception(self)
	get_node("RayCast2D").add_exception(get_node("hover"))

func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		get_tree().reload_current_scene()
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
		do_cap_velocity()
		do_powerup(delta)
		do_move(delta)
	else:
		stop(delta)
	
	do_update_background_color()
	do_update_level_porcentage()

func do_move(delta):
	if get_node("RayCast2D").is_colliding():
		var dir = Vector2(1, 0).rotated(get_rot())
		var speed_dir = 0
		if Input.is_action_pressed("ui_left"):
			speed_dir = -1
		elif Input.is_action_pressed("ui_right"):
			speed_dir = 1
		if Input.is_action_pressed("speed_up") and powerup > 0:
			speed_dir = direction
		
		var impulse = Vector2(speed_dir * FORCE_SPEED, 0) * dir * delta
		if Input.is_action_pressed("speed_up") and powerup > 0:
			impulse *= FORCE_SPEED_MULTIPLIER
		apply_impulse(Vector2(), impulse)
		get_node("hover").apply_impulse(Vector2(), impulse)
		get_node("hover1").apply_impulse(Vector2(), impulse)
		
		# update gas tank
		if impulse != Vector2():
			self.gas_tank = max(0, gas_tank - (GAS_USAGE_SEC * delta))
			if gas_tank == 0:
				do_end()
		
	# turn
	else:
		var f = Vector2()
		if Input.is_action_pressed("ui_left"):
			f.x = -1
		elif Input.is_action_pressed("ui_right"):
			f.x = 1
		if f!=Vector2():
			var av = get_angular_velocity()
			av += f.x * FORCE_TURN
			set_angular_velocity(av * delta)

func do_powerup(delta):
	if powerup > 0 and Input.is_action_pressed("speed_up"):
		get_node("graphics/boost/Particles2D").set_emitting(true)
		FORCE_SPEED_MULTIPLIER = 2.0
		powerup -= delta
		if powerup <= 0:
			FORCE_SPEED_MULTIPLIER = 1
			Globals.get("GUI").show_speed_up(false)
	else:
		get_node("graphics/boost/Particles2D").set_emitting(false)

func do_cap_velocity():
	cap_vel(self)
	cap_vel(get_node("hover"))
	cap_vel(get_node("hover1"))

func cap_vel(node):
	var vel = node.get_linear_velocity()
	vel.x = clamp(vel.x, -SPEED_MAX_X, SPEED_MAX_X)
	node.set_linear_velocity(vel)
	

func do_update_background_color():
	Globals.get("GUI").set_background_color(get_global_pos())

func do_update_level_porcentage():
	var pos = get_global_pos()
	var porc = clamp(pos.x / Globals.get("Level").level_length, 0, 1)
	Globals.get("GUI").set_level_porcentage(porc)

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
	engine_breaks += 1
	
	if engine_breaks == 1:
		get_node("smokes/smoke").set_emitting(true)
	elif engine_breaks == 2:
		get_node("smokes/smoke1").set_emitting(true)
	if engine_breaks > 2:
		do_end()

func stop(delta):
	var vel = get_linear_velocity() * 0.95
	set_linear_velocity(vel)
	get_node("hover").set_linear_velocity(vel)
	get_node("hover1").set_linear_velocity(vel)

func powerup():
	powerup = POWER_UP_SECS
	Globals.get("GUI").show_speed_up(true)

func pickup_gas(gas):
	self.gas_tank = min(gas_tank + 0.4, 1.0)

func do_win():
	win = true
	do_end()

func do_end():
	ended = true
	set_process_input(false)
	Globals.get("GUI").show_game_over()
