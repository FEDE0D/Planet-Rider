
extends Node

var engine_snd_id = -1
var powerup_snd_id = -1

func _ready():
	Globals.set("Sounds", self)

func musicStop():
	get_node("Music").stop()

func musicPlay():
	get_node("Music").play()

func soundPlay(snd):
	get_node("Sounds").play(snd)

func soundPlayBox():
	if randi() % 2 == 0:
		get_node("Sounds").play("box_1")
	else:
		get_node("Sounds").play("box_2")

func soundPlayEngine():
	if not get_node("Sounds").is_voice_active(engine_snd_id):
		engine_snd_id = get_node("Sounds").play("engine")

func soundStopEngine():
	get_node("Sounds").stop(engine_snd_id)

func soundPlayPowerup():
	if not get_node("Sounds").is_voice_active(powerup_snd_id):
		powerup_snd_id = get_node("Sounds").play("powerup")

func soundStopPowerup():
	get_node("Sounds").stop(powerup_snd_id)