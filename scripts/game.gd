extends Control

const file_functions = preload("res://scripts/file_functions.gd")

var button2_counter=0
var dialogue_files:Array

var dialogue:Array[Dictionary]
var dialogue_lines:Array

var dialogue_index:int=0
var dialogue_line_count:int=0

var file_index=0
var file_count=0

var final_decision=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_files= file_functions.get_dialogue_files("res://dialogue")
	file_count=dialogue_files.size()
	for file in dialogue_files:
		dialogue.append(file_functions.load_json_file("res://dialogue/"+file))
	dialogue_lines=dialogue[file_index]['dialogue_lines']
	dialogue_line_count=dialogue[file_index]['dialogue_lines'].size()
	$ParkUI/RichTextLabel.text=dialogue_lines[0]['text']
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_button_pressed() -> void:
	#if ($NightUI.visible):
		#$NightUI.visible=false
		#$VBoxContainer/Button.text="room OFF"
	#else:
		#$NightUI.visible=true
		#$VBoxContainer/Button.text="room ON"
	final_decision+=dialogue_lines[0]["stat_changes"]["final_decision"]
	handle_next_file()


func _on_button_2_pressed() -> void:
	#if ($ParkUI.visible):
		#$ParkUI.visible=false
		#$VBoxContainer/Button2.text="park OFF"
	#else:
		#$ParkUI.visible=true
		#$VBoxContainer/Button2.text="park ON"
	final_decision+=dialogue_lines[1]["stat_changes"]["final_decision"]
	handle_next_file()

func _on_button_3_pressed() -> void:
	button2_counter+=1
	$VBoxContainer/Button3.text="counter at "+str(button2_counter)

func _on_next_button_pressed() -> void:
	dialogue_index+=1
	if (dialogue_index==dialogue_line_count):
		handle_next_file()
	else:
		$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
func handle_next_file()->void:
	file_index+=1
	dialogue_index=0
	print(file_count)
	if file_index==file_count:
		$ParkUI/RichTextLabel.text="end of the game"
		$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=true
	else:
		if(dialogue[file_index]['file_type']==0):
			$VBoxContainer.visible=false
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=false
			#this means we're on the final stretch
			if(file_index==(file_count-2) and (final_decision>0)):
				file_index+=1
			dialogue_lines=dialogue[file_index]['dialogue_lines']
			dialogue_line_count=dialogue[file_index]['dialogue_lines'].size()
			$ParkUI/RichTextLabel.text=dialogue_lines[dialogue_index]['text']
			if(file_index==(file_count-2)):
				file_index+=1
		else:
			$VBoxContainer.visible=true
			$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled=true
			if(dialogue[file_index]['file_type']==1):
				dialogue_lines=dialogue[file_index]['choices']
				$ParkUI/RichTextLabel.text=dialogue[file_index]['question']['text']
				$VBoxContainer/Button.text=dialogue_lines[0]["text"]
				$VBoxContainer/Button2.text=dialogue_lines[1]["text"]
		
