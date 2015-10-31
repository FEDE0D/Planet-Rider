
extends Control

func _ready():
	get_tree().set_auto_accept_quit(false)
	pass

func _on_btnPlay_pressed():
	get_tree().change_scene("res://scenes/level/level.scn")

func _on_btnQuit_pressed():
	get_tree().quit()

func _on_btnCredits_pressed():
	get_tree().change_scene("res://scenes/screens/credits/credits.scn")
