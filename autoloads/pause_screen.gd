extends CanvasLayer
var titlescreenscne = preload("res://Scenes/MainMenu/start_screen.tscn")

var paused:bool = false
var allowPausing:bool = true :
	set(valie):
		allowPausing = valie
		if(!allowPausing and paused):
			unpause()

var stack = []

func pause():
	stack.push_back(Input.mouse_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	visible = true
	paused = true	
	
func unpause(mode:Input.MouseMode=-1):
	if(mode == -1):
		Input.mouse_mode = stack.pop_back()
	else:
		stack.pop_back()
		Input.mouse_mode = mode
	get_tree().paused = false
	visible = false
	paused = false
	
	
func _ready():
	visible = false

func _process(_delta: float) -> void:
	
	if(allowPausing and Input.is_action_just_pressed("pause")):
		if(paused):
			unpause()
		else:
			pause()
		pass
	
	pass


func _on_resume_pressed() -> void:
	unpause()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	unpause(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_packed(titlescreenscne)
	#get_tree().quit()
	pass # Replace with function body.
