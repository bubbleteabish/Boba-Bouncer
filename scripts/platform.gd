extends RigidBody2D

@export var platform_info: PlatformResource
signal bounced_on

func _ready() -> void:
	$Sprite.texture = platform_info.sprite
	position.x = 200
	position.y = 200

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		bounced_on.emit()
