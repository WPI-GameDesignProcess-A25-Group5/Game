@tool
extends VBoxContainer

var data = []

var attributionsNode := preload("res://Credits/Sections/Attributions/attributions_credit.tscn")
var CRSep := preload("res://Credits/Sections/Seperators/CR_Seperator.tscn")

var containerQueue :=[]

func _ready() -> void:
	#print(data)
	#print(Engine.get_author_info())
	var cpriteInfo=Engine.get_copyright_info()
	#for a in cpriteInfo:
		#print(a)
	data+=cpriteInfo
		
	$Tile.text = "Attributions"
	for author in data:
		var authorCredit = attributionsNode.instantiate()
		authorCredit.attribName=author["name"]
		authorCredit.copyright = ""
		authorCredit.license = ""
		for part in author["parts"]:
				for i in part["copyright"].size():
					authorCredit.copyright+=part["copyright"][i]
					authorCredit.copyright+="\n"
				authorCredit.license=part["license"]
		containerQueue.push_back(authorCredit)

func _process(_delta: float) -> void:
	var colms = %ColumnCredits
	var colms2 = %ColumnCredits2
	var authorCredit = containerQueue.pop_front()
	if(authorCredit):
		if(colms.size.y<colms2.size.y):
			colms.add_child(authorCredit)
		else:
			colms2.add_child(authorCredit)
		authorCredit.add_child(CRSep.instantiate())
	if(!authorCredit):
		var botLeft=colms.get_child(colms2.get_child_count()-1)
		var botRight=colms2.get_child(colms2.get_child_count()-1)
		var sepRight = botLeft.get_child(botLeft.get_child_count()-1) 
		var sepLeft = botRight.get_child(botRight.get_child_count()-1)
		if(sepLeft.get_child(0) is HSeparator and sepRight.get_child(0) is HSeparator):
			sepLeft.queue_free()
			sepRight.queue_free()
	
