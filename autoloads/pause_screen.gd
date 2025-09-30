extends CanvasLayer

var paused:bool = false
var allowPausing:bool = true


func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	visible = true
	paused = true	
	
func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false
	paused = false
	
	
	
func _ready():
	visible = false

func _process(delta: float) -> void:
	
	if(allowPausing and Input.is_action_just_pressed("pause")):
		if(paused):
			unpause()
		else:
			pause()
		pass
	
	pass
