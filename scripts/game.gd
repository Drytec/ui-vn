extends Control

const file_functions = preload("res://scripts/file_functions.gd")


var dialogue_files:Array

var dialogue:Array[Dictionary]
var dialogue_lines:Array

var dialogue_index:int=0
var dialogue_line_count:int=0

var file_index=0
var file_count=0

var final_decision=0
var decision_list:Array[int]=[]

var characters:Dictionary[String,Texture2D]

var game_ended=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_files= file_functions.get_dialogue_files("res://dialogue")
	file_count=dialogue_files.size()
	characters["character_a.png"]=load("res://images/character_a.png")
	characters["character_b.png"]=load("res://images/character_b.png")
	for file in dialogue_files:
		dialogue.append(file_functions.load_json_file("res://dialogue/"+file))
	dialogue_lines=dialogue[file_index]['dialogue_lines']
	dialogue_line_count=dialogue[file_index]['dialogue_lines'].size()
	$ParkUI/RichTextLabel.text=dialogue_lines[0]['text']
	$VBoxContainer.visible=false
	#$ParkUI/RichTextLabel.visible_ratio=0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_button_pressed() -> void:
	final_decision+=dialogue_lines[0]["stat_changes"]["final_decision"]
	decision_list.append(dialogue_lines[0]["stat_changes"]["final_decision"])
	handle_next_file()

func _on_button_2_pressed() -> void:
	final_decision+=dialogue_lines[1]["stat_changes"]["final_decision"]
	decision_list.append(dialogue_lines[1]["stat_changes"]["final_decision"])
	handle_next_file()

func _on_next_button_pressed() -> void:
	if (dialogue_index==(dialogue_line_count-1)):
		handle_next_file()
	else:
		dialogue_index+=1
		print("dialogue_index: "+str(dialogue_index))
		$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
	update_character()

func _on_back_button_pressed() -> void:
	print("dialogue_index: "+str(dialogue_index))
	print("file_index: "+str(file_index))
	if (dialogue_index==0):
		print("--------going back to previous file")
		handle_previous_file()
	elif(game_ended):
		game_ended=false
		$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
	else:
		dialogue_index-=1
		$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
	update_character()

func _on_history_button_pressed() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func handle_previous_file()-> void:
	print(file_count)
	if file_index==0 and dialogue_index==0:
		print("we're in the beginning of the file")
	else:
		file_index-=1
		if(file_index==file_count-2):
			file_index-=1
		if(dialogue[file_index]['file_type']==0):
			$VBoxContainer.visible=false
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=false
			dialogue_lines=dialogue[file_index]['dialogue_lines']
			dialogue_line_count=dialogue[file_index]['dialogue_lines'].size()
			dialogue_index=dialogue_line_count-1
			$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
		elif(dialogue[file_index]['file_type']==1):
			$VBoxContainer.visible=true
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=true
			dialogue_lines=dialogue[file_index]['choices']
			$ParkUI/RichTextLabel.text=dialogue[file_index]['question']['text']
			$VBoxContainer/Button.text=dialogue_lines[0]["text"]
			$VBoxContainer/Button2.text=dialogue_lines[1]["text"]
			final_decision-=decision_list[-1]
			decision_list.pop_back()
		$ParkUI/TextureRect.texture=load("res://images/"+dialogue[file_index]["background"])

func handle_next_file()->void:
	if file_index==file_count-1 or file_index==file_count-2:
		$ParkUI/RichTextLabel.text="end of the game"
		$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=true
		game_ended=true
		print("dialogue_index" +str(dialogue_index))
	else:
		file_index+=1
		dialogue_index=0
		print(file_count)
		print("file_index in handle_next_file(): " + str(file_index))
		if(dialogue[file_index]['file_type']==0):
			$VBoxContainer.visible=false
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=false
			#this means we're on the final stretch
			if(file_index==(file_count-2) and (final_decision>0)):
				file_index+=1
			dialogue_lines=dialogue[file_index]['dialogue_lines']
			dialogue_line_count=dialogue[file_index]['dialogue_lines'].size()
			$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
			#if(file_index==(file_count-2)):
				#file_index+=1
		elif(dialogue[file_index]['file_type']==1):
			$VBoxContainer.visible=true
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=true
			dialogue_lines=dialogue[file_index]['choices']
			$ParkUI/RichTextLabel.text=dialogue[file_index]['question']['text']
			$VBoxContainer/Button.text=dialogue_lines[0]["text"]
			$VBoxContainer/Button2.text=dialogue_lines[1]["text"]
		$ParkUI/TextureRect.texture=load("res://images/"+dialogue[file_index]["background"])

func update_character()->void:
		
	if((dialogue[file_index]["file_type"]==0)and dialogue[file_index]["dialogue_lines"][dialogue_index]["side_image"]):
		print("debug")
		$ParkUI/character_left.texture=characters[dialogue[file_index]["dialogue_lines"][dialogue_index]["side_image"]]
	elif((dialogue[file_index]["file_type"]==1)and dialogue[file_index]["question"]["side_image"]):
		$ParkUI/character_left.texture=characters[dialogue[file_index]["question"]["side_image"]]
	else:
		$ParkUI/character_left.texture=null
