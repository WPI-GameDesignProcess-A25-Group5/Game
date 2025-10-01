extends CanvasLayer

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
	
func unpause():
	Input.mouse_mode = stack.pop_back()
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
