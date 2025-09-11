extends Node2D
var creditsScene = preload("res://Scenes/Credits/Credits.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


var buttonPressed = ""
func _on_start_button_pressed() -> void:
	$Buttons/Click.play()
	buttonPressed = "start"
	

func _on_credits_button_pressed() -> void:
	$Buttons/Click.play()
	buttonPressed = "credits"


func _on_exit_button_pressed() -> void:
	$Buttons/Click.play()
	buttonPressed = "exit"
	


func _on_click_sound_finished() -> void:
	match buttonPressed:
		"start":
			pass
		"credits":
			get_tree().change_scene_to_packed(creditsScene)
		"exit":
			get_tree().quit(0)
	pass # Replace with function body.
