extends Node
class_name Level

var coffee_collected = false
var coffees = []
signal coffeesGotten

func _ready() -> void:
	PauseScreen.allowPausing = true
	Transition.endTransition()

func _exit_tree() -> void:
	PauseScreen.allowPausing = false	

func add_coffee(coffee):
	coffees.push_back(coffee)

func collecte_coffee(cofee):
	for i in coffees:
		if i == cofee:
			var t = coffees.find(i)
			coffees.remove_at(t)
			break
	if(coffees.size()==0):
		coffee_collected = true
		coffeesGotten.emit()
	else:
		coffee_collected = false
	
#func _on_player_dies(_position: Vector2) -> void:
	#$PlayerRespawnTimer.start()
	#pass # Replace with function body.
#
#
#func _on_player_respawn_timer_timeout() -> void:
	#$Player.respawn()
	#pass # Replace with function body.
