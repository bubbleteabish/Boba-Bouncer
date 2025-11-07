extends Area2D

@export var speed := -300

func _process(delta: float) -> void:
	position.y += speed * delta


func _on_area_entered(area: Area2D) -> void:
	Autoloads.hit_enemy.emit(area)
