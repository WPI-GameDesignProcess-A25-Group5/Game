extends Node2D
var creditsScene = preload("res://Scenes/Credits/Credits.tscn")
var testSence = preload("res://Scenes/TestScene/test_scene.tscn")
var example_map=preload("res://Scenes/Map.tscn")

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
	
func _on_example_pressed() -> void:
	$Buttons/Click.play()
	buttonPressed = "example"

func _on_click_sound_finished() -> void:
	match buttonPressed:
		"start":
			get_tree().change_scene_to_packed(testSence)
			pass
		"credits":
			get_tree().change_scene_to_packed(creditsScene)
		"example":
			get_tree().change_scene_to_packed(example_map)
		"exit":
			get_tree().quit(0)
	pass # Replace with function body.



func _on_version_notes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/VersionNotes/version_notes.tscn")
	pass # Replace with function body.
