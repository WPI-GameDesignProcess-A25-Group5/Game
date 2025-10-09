extends Node




func _ready() -> void:
	PauseScreen.allowPausing = false
	Transition.endTransition()
	if(EventBus.coffeecollected):
		$CanvasLayer/AnimationPlayer.play("coffee")
	else:
		$CanvasLayer/AnimationPlayer.play("nocoffee")
		

func _exit_tree() -> void:
	PauseScreen.allowPausing = false	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Transition.startTransition()
	var temp = func(tree):
		tree.change_scene_to_file("res://Scenes/MainMenu/start_screen.tscn")
		PauseScreen.unpause(Input.MOUSE_MODE_VISIBLE)
		#tree.change_scene_to_packed(bossRoom)
	Transition.connect("readyTotransition",temp)
	pass # Replace with function body.
