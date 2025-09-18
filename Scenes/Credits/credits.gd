@tool
extends Control

signal ExitCreditsScene

var mainMenuScene = load("res://Scenes/MainMenu/start_screen.tscn")

enum Sections {
	Developers,
	Attributions,
}
var developersSection = preload("res://Scenes/Credits/Sections/Developers/section_credits.tscn")
var attributionsSection = preload("res://Scenes/Credits/Sections/Attributions/section_attributions.tscn")
var sectionSeperator = preload("res://Scenes/Credits/Sections/Seperators/Section_Seperator.tscn")

var hasNotLeftYet = true

func _ready():
	hasNotLeftYet=true
	ExitCreditsScene.connect(onExitCreditScene)
	# read in credits file
	var creditsFile := FileAccess.open("res://Scenes/Credits/Credits.json",FileAccess.READ).get_as_text()
	var credits:=JSON.new()
	var result = credits.parse(creditsFile)
	var data = []
	if result!=OK:
		push_error("Error Parsing Credits File");
		return
	else:
		data = credits.data
# TODO: make Title UI lable to instantiate
	var count = 0
	for Section in data:
		%CreditsBox/VBoxContainer.add_child(createCreditsSection(data[Section],Sections.get(Section)))
		count+=1
		if(count<data.size()):
			%CreditsBox/VBoxContainer.add_child(sectionSeperator.instantiate())
			
	%AnimationPlayer.play("fade in")

var autoscroll = true

func _process(delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(autoscroll):
			if(Input.is_action_pressed("ui_accept")):
				%CreditsBox.position.y -=50*10*delta
				$AudioStreamPlayer.pitch_scale = 10;
			else:
				%CreditsBox.position.y -=50*delta
				$AudioStreamPlayer.pitch_scale = 1
		var scrolling = Input.get_axis("ui_up","ui_down")
		if(abs(scrolling)>0.1):
			autoscroll = false
			$"Scroll Timer".stop()
			%CreditsBox.position.y +=scrolling*50*10*delta
		elif(autoscroll==false and $"Scroll Timer".is_stopped()):
			$"Scroll Timer".start()
			pass
		if((Input.is_action_just_pressed("ui_cancel")|| (-%VBoxContainer.global_position.y)>%VBoxContainer.size.y)and hasNotLeftYet):
			ExitCreditsScene.emit()
		pass
	#print( (-%CreditsBox.position.y)>%VBoxContainer.size.y)

func createCreditsSection(rolesinfo,sectionType:Sections):
	var sec
	match sectionType:
		Sections.Developers:
			sec = developersSection.instantiate()
		Sections.Attributions:
			sec = attributionsSection.instantiate()
			
	sec.data = rolesinfo
	return sec
	
func onExitCreditScene():
	hasNotLeftYet=false
	print("About to Leave Credit Scene")
	$AnimationPlayer.play("fade out")
	$AnimationPlayer.animation_finished.connect(leaveCreditScene)
	
func leaveCreditScene(_what):
	print("Exiting Credit Scene")
	get_tree().change_scene_to_packed(mainMenuScene)
	pass


func _on_scroll_timer_timeout() -> void:
	autoscroll=true
	pass # Replace with function body.
