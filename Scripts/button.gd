extends Node2D
var creditsScene = preload("res://Credits/Credits.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	print("Start")
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	print("Credits")
	get_tree().change_scene_to_packed(creditsScene)
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	print("Exit")
	pass # Replace with function body.
