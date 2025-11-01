extends Control

#var main_menu = preload("res://scenes/main_menu.tscn")

@export var brows : Array[Texture]
@export var eyes : Array[Texture]
@export var mouths : Array[Texture]

var selected_brows := 0
var selected_eyes := 0
var selected_mouth := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.process_mode = Node.PROCESS_MODE_DISABLED


func _on_brows_pressed() -> void:
	selected_brows += 1
	if selected_brows > brows.size() - 1: selected_brows = 0
	$Player/Body/Brows.texture = brows[selected_brows]
	Autoloads.current_brows = brows[selected_brows]


func _on_eyes_pressed() -> void:
	selected_eyes += 1
	if selected_eyes > eyes.size() - 1: selected_eyes = 0
	$Player/Body/Eyes.texture = eyes[selected_eyes]
	Autoloads.current_eyes = eyes[selected_eyes]


func _on_mouth_pressed() -> void:
	selected_mouth += 1
	if selected_mouth > mouths.size() - 1: selected_mouth = 0
	$Player/Body/Mouth.texture = mouths[selected_mouth]
	Autoloads.current_mouth = mouths[selected_mouth]


func _on_done_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
