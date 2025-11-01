extends MarginContainer

#const main = preload("res://scenes/main.tscn")
#var character_creator = preload("res://scenes/character_creator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_char_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/character_creator.tscn")
	
