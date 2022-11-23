extends Node

onready var label = $Label
onready var buttons = $GridContainer.get_children()
onready var play_again_button = $PlayAgain

var current_player = "X"

func _ready():
	play_again_button.visible = false
	play_again_button.connect("pressed",self,"on_PlayAgain_pressed")
	update_label()
	for button in buttons:
		button.connect("pressed",self,"on_Button_pressed",[button])

func update_label(text = "Player {current_player} turn"):
	label.text = text.format({"current_player":current_player})

func on_Button_pressed(button):
	button.text = current_player
	button.disabled = true
	
	if is_board_full():
		update_label("Tie")
		play_again_button.visible = true
	elif is_current_player_victory():
		update_label("Player {current_player} wins!")
		disable_buttons()
		play_again_button.visible = true
	else:
		change_turn()
		update_label()

func change_turn():
	if current_player == "X":
		current_player = "O"
	elif current_player == "O":
		current_player = "X"

func is_board_full():
	for button in buttons:
		if button.text.length() == 0:
			return false
	return true

func is_current_player_victory():
	var win_conditions = [
		[0,1,2],
		[3,4,5],
		[6,7,8],
		[0,3,6],
		[1,4,7],
		[2,5,8],
		[0,4,8],
		[2,4,6]
	]
	var cells = get_current_player_cells()
	for condition in win_conditions:
		if cells.find(condition[0]) != -1 and cells.find(condition[1]) != -1 and cells.find(condition[2]) != -1:
			return true
	return false

func get_current_player_cells():
	var result = []
	for button in buttons:
		if button.text == current_player:
			var index = buttons.find(button)
			result.append(index)
	return result

func disable_buttons():
	for button in buttons:
		button.disabled = true

func on_PlayAgain_pressed():
	get_tree().reload_current_scene()
