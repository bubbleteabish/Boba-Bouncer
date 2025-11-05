extends CharacterBody2D


@export var speed := 300.0
@export var jump_velocity := -600.0
@export var bounce_velocity := -900
@export var rotation_speed := 1.0

var last_dir := 0.0
var hit_ground = false
var plat_hit
var plat_name 

var can_shoot = true
var boba_bullet = preload("res://scenes/boba_bullet.tscn")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		hit_ground = false
	
	if is_on_floor() and hit_ground == false:
		hit_ground = true
		$Body/AnimationPlayer.play("bounce")
		$Particles.global_position = self.global_position
		if plat_name == "Foam":
				$Particles/FoamParticles.restart()
				$Particles/FoamParticles.emitting = true
		if plat_name == "Popping":
			Autoloads.hit_platform.emit(plat_hit)
		if plat_name == "Pudding":
			velocity.y = bounce_velocity
		else:
			velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var fire := Input.get_action_strength("ui_up")
	if direction:
		last_dir = direction
		velocity.x = direction * speed
		$Body.rotation += rotation_speed * direction * delta
		rotation_speed = move_toward(rotation_speed, 8, 1)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		var ro_delta = randf_range(.1, .5)
		rotation_speed = move_toward(rotation_speed, 0, ro_delta)
		$Body.rotation += rotation_speed * last_dir * delta
	if fire > 0 and can_shoot:
		var bullet = boba_bullet.instantiate()
		bullet.global_position.y = self.global_position.y - ($Body.texture.get_height()/2)
		bullet.global_position.x = self.global_position.x
		get_parent().add_child(bullet)
		can_shoot = false
		$Timer.start(1.5)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	plat_name = body.get_child(0).name
	plat_hit = body
	

func _on_timer_timeout() -> void:
	can_shoot = true
