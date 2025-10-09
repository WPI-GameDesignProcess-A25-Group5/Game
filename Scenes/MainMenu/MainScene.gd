extends Control
var creditsScene = preload("res://Scenes/Credits/Credits.tscn")
var testSence = preload("res://Scenes/TestScene/test_scene.tscn")
var example_map=preload("res://Scenes/Map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PauseScreen.allowPausing = false
	if(Transition.visible):
		Transition.endTransition()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


var buttonPressed = ""
func _on_start_button_pressed() -> void:
	$Buttons/Click.play()
	$Buttons/VBoxContainer/StartButton.disabled = true
	buttonPressed = "start"
	

func _on_credits_button_pressed() -> void:
	$Buttons/Click.play()
	$Buttons/VBoxContainer/CreditsButton.disabled = true
	buttonPressed = "credits"


func _on_exit_button_pressed() -> void:
	$Buttons/Click.play()
	$Buttons/VBoxContainer/ExitButton.disabled= true
	buttonPressed = "exit"
	
func _on_example_pressed() -> void:
	$Buttons/Click.play()
	$Buttons/VBoxContainer/TestButton.disabled = true
	buttonPressed = "test"

func _on_click_sound_finished() -> void:
	match buttonPressed:
		"test":
			Transition.startTransition()
			var temp = func(tree):
				tree.change_scene_to_packed(testSence)
			Transition.connect("readyTotransition",temp)
			pass
		"credits":
			get_tree().change_scene_to_packed(creditsScene)
		"start":
			Transition.startTransition()
			var temp =func(tree) :
				tree.change_scene_to_packed(example_map)
			Transition.connect("readyTotransition",temp)
		"exit":
			get_tree().quit(0)
	pass # Replace with function body.



func _on_version_notes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/VersionNotes/version_notes.tscn")
	pass # Replace with function body.
