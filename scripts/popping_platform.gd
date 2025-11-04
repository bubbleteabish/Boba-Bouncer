extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoloads.hit_platform.connect(Callable(self, "_on_platform_hit"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_platform_hit(platform) -> void:
	if platform == self:
		for part in $Particles.get_children():
			part.restart()
			part.emitting = true
		$AnimationPlayer.play("pop")
		await $AnimationPlayer.animation_finished
		$Particles.hide()
		self.process_mode = Node.PROCESS_MODE_DISABLED
