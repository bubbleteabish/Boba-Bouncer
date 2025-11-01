extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(bounced_on)


func bounced_on(body):
	if body is CharacterBody2D:
		var character_body = body as CharacterBody2D
		if character_body.velocity.y >= 0.0 or character_body.velocity.y == body.bounce_velocity:
			$AnimationPlayer.play("bounce")
