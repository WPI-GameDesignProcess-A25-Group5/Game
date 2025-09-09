@tool
extends Control

signal ExitCreditsScene

enum Sections {
	Developers,
	Attributions,
}
var developersSection = preload("res://Credits/Sections/Developers/section_credits.tscn")
var attributionsSection = preload("res://Credits/Sections/Attributions/section_attributions.tscn")

var sectionSeperator = preload("res://Credits/Sections/Seperators/Section_Seperator.tscn")
var hasNotLeftYet = true
func _ready():
	hasNotLeftYet=true
	ExitCreditsScene.connect(onExitCreditScene)
	# read in credits file
	var creditsFile := FileAccess.open("res://Credits/Credits.json",FileAccess.READ).get_as_text()
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

func _process(delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(Input.is_action_pressed("ui_accept")):
			%CreditsBox.position.y -=50*10*delta
			$AudioStreamPlayer.pitch_scale = 10;
		else:
			%CreditsBox.position.y -=50*delta
			$AudioStreamPlayer.pitch_scale = 1
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
	pass
