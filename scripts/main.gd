extends Node2D

@export var max_platforms := 30
@export var platform_gaps : Vector2i

var foam_platform = preload("res://scenes/foam_platform.tscn")
var pudding_platform = preload("res://scenes/pudding_platform.tscn")
var platforms = []
var last_platform
var screen_size
var start_position

@onready var restart_btn: Button = $GameOver/VBoxContainer/RestartBtn

func _ready() -> void:
	restart_btn.pressed.connect(new_game)
	start_position = $Player.global_position
	screen_size = get_window().size
	last_platform = $StartingPlatforms/FoamPlatform
	$Player/Body/Brows.texture = Autoloads.current_brows
	$Player/Body/Eyes.texture = Autoloads.current_eyes
	$Player/Body/Mouth.texture = Autoloads.current_mouth

func new_game():
	last_platform = $StartingPlatforms/FoamPlatform
	for plat in platforms:
		plat.queue_free()
	platforms.clear()
	$Player.global_position = start_position
	$Player/Camera2D.limit_bottom = screen_size.y
	$GameOver.hide()
	get_tree().paused = false
	

func _process(_delta: float) -> void:
	remove_platforms()
	generate_platforms()
	if $Player.global_position.y < $Player/Camera2D.limit_bottom - screen_size.y:
		$Player/Camera2D.limit_bottom = $Player.global_position.y + screen_size.y
	if $Player.global_position.y > $Player/Camera2D.limit_bottom:
		game_over()

func generate_platforms():
	if platforms.is_empty() or platforms.size() < max_platforms:
		var pick_plat = randi_range(0,120)
		var platform
		if pick_plat < 10:
			platform = pudding_platform.instantiate()
		else:
			platform = foam_platform.instantiate()
		var platform_length = platform.get_node("Sprite2D").texture.get_width()
		var platform_scale = platform.scale
		platform_length = platform_length * platform_scale.x
		var platform_x : int
		var offset : int = (screen_size.x / 2)
		if last_platform.global_position.x < offset:
			platform_x = clamp(randi_range(offset, screen_size.x ),offset, screen_size.x - platform_length)
		else:
			platform_x = clamp(randi() % offset, 0, screen_size.x - platform_length)
		var platform_y = last_platform.global_position.y - randi_range(platform_gaps.x,platform_gaps.y)
		last_platform = platform
		platform.global_position = Vector2i(platform_x, platform_y)
		add_child(platform)
		platforms.append(platform)

func remove_platforms():
	for plat in platforms:
		if plat.global_position.y > $Player.global_position.y + screen_size.y:
			plat.queue_free()
			platforms.erase(plat)

func game_over():
	get_tree().paused = true
	$GameOver.show()


func _on_main_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
