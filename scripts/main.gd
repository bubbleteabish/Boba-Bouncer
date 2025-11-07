extends Node2D

@export var max_platforms := 30
@export var max_obstacles := 5
@export var platform_gaps : Vector2i

var foam_platform = preload("res://scenes/foam_platform.tscn")
var pudding_platform = preload("res://scenes/pudding_platform.tscn")
var popping_platform = preload("res://scenes/popping_platform.tscn")
var platforms = []
var platform_length
var platform_scale
var platform_x
var platform_y
var last_platform
var ice_cube = preload("res://scenes/ice_cube.tscn")
var bad_bean = preload("res://scenes/bad_bean.tscn")
var obstacles = []
var screen_size
var start_position

@onready var restart_btn: Button = $GameOver/VBoxContainer/RestartBtn

func _ready() -> void:
	restart_btn.pressed.connect(new_game)
	Autoloads.player_hit.connect(game_over)
	start_position = $Player.global_position
	screen_size = get_window().size
	last_platform = $StartingPlatforms/FoamPlatform


func new_game():
	last_platform = $StartingPlatforms/FoamPlatform
	for plat in platforms:
		plat.queue_free()
	platforms.clear()
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	$Player.global_position = start_position
	$Player/Camera2D.limit_bottom = screen_size.y
	Autoloads.new_game.emit()
	$GameOver.hide()
	get_tree().paused = false


func _process(_delta: float) -> void:
	remove_platforms()
	generate_platforms()
	remove_obstacles()
	add_obstacle()
	if $Player.global_position.y < $Player/Camera2D.limit_bottom - screen_size.y:
		$Player/Camera2D.limit_bottom = $Player.global_position.y + screen_size.y
	if $Player.global_position.y > $Player/Camera2D.limit_bottom:
		Autoloads.player_fell.emit()
		game_over()

func generate_platforms():
	if platforms.is_empty() or platforms.size() < max_platforms:
		var pick_plat = randi_range(0,300)
		var platform
		if pick_plat <= 10:
			platform = pudding_platform.instantiate()
		elif pick_plat > 10 and pick_plat <= 20:
			platform = popping_platform.instantiate()
		else:
			platform = foam_platform.instantiate()
		set_platform(platform)
		var offset : int = (screen_size.x / 2)
		if last_platform.global_position.x < offset:
			platform_x = clamp(randi_range(offset, screen_size.x ),offset, screen_size.x - platform_length)
		else:
			platform_x = clamp(randi() % offset, 0, screen_size.x - platform_length)
		platform_y = last_platform.global_position.y - randi_range(platform_gaps.x,platform_gaps.y)
		last_platform = platform
		platform.global_position = Vector2i(platform_x, platform_y)
		add_child(platform)
		platforms.append(platform)

func set_platform(platform):
	platform_length = platform.get_node("Sprite2D").texture.get_width()
	platform_scale = platform.scale
	platform_length = platform_length * platform_scale.x

func remove_platforms():
	for plat in platforms:
		if plat.global_position.y > $Player.global_position.y + screen_size.y:
			plat.queue_free()
			platforms.erase(plat)

func add_obstacle():
	if obstacles.is_empty() or obstacles.size() < max_obstacles:
		var rando = randi_range(0,100)
		var obstacle
		if rando <= 80:
			obstacle = ice_cube.instantiate()
			var randy = randi_range(screen_size.y * 5, screen_size.y * 25)
			obstacle.global_position.y = $Player.global_position.y - randy
			obstacle.global_position.x = randi_range(0, screen_size.x)
		else:
			obstacle = bad_bean.instantiate()
			obstacle.global_position.x = last_platform.global_position.x + 69
			obstacle.global_position.y = last_platform.global_position.y - 48
		add_child(obstacle)
		obstacles.append(obstacle)

func remove_obstacles():
	for obs in obstacles:
		if obs.global_position.y > $Player/Camera2D.limit_bottom:
			obs.queue_free()
			obstacles.erase(obs)

func game_over():
	get_tree().paused = true
	$GameOver.show()


func _on_main_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
