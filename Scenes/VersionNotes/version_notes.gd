extends Control

@export var backButtonGoesTo:PackedScene



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(backButtonGoesTo)
	pass # Replace with function body.
