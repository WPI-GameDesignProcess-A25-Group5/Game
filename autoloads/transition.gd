extends CanvasLayer
class_name LevelTransition

signal readyTotransition (tree:SceneTree)
signal transitionFinished

var transitionWaiting = false


func startTransition():
	if(!transitionWaiting):
		$ColorRect.modulate = Color.TRANSPARENT
		visible = true
		print("pin")
		create_tween().tween_property($ColorRect,"modulate",Color.WHITE,0.3).finished.connect(func():transitionWaiting=true; readyTotransition.emit(get_tree()))

func endTransition():
	if(transitionWaiting):
		$ColorRect.modulate = Color.WHITE
		create_tween().tween_property($ColorRect,"modulate",Color.TRANSPARENT,0.4).finished.connect(func():visible = false; transitionWaiting=false; transitionFinished.emit())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
