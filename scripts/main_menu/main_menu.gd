extends Node

@onready var hovered: AudioStreamPlayer = $CanvasLayer/Hovered
@onready var clicked: AudioStreamPlayer = $CanvasLayer/Clicked
@onready var button_start: Button = $CanvasLayer/Control/Panel/MarginContainer/VBoxContainer/BUTTON_Start
@onready var button_exit: Button = $CanvasLayer/Control/Panel/MarginContainer/VBoxContainer/BUTTON_Exit


func start_button_hovered() -> void:
	hovered.play()

func exit_button_hovered() -> void:
	hovered.play()

func start_button_clicked() -> void:
	button_start.visible = false
	button_exit.visible = false
	clicked.play()
	await get_tree().create_timer(0.5).timeout
	print("GO TO GAME")

func exit_button_clicked() -> void:
	button_start.visible = false
	button_exit.visible = false
	clicked.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
