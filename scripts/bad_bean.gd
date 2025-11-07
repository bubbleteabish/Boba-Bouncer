extends Area2D

func _ready() -> void:
	Autoloads.hit_enemy.connect(Callable(self, "got_hit"))

func got_hit(enemy):
	if enemy == self:
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("dead")
		await $AnimationPlayer.animation_finished
		self.process_mode = Node.PROCESS_MODE_DISABLED
