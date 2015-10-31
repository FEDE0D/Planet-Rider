
extends Control

func _ready():
	pass

func setMessage(message):
	get_node("Label").set_text(message)

func _on_Button_pressed():
	hide()
	Globals.get("GUI").fadeAndReload()
