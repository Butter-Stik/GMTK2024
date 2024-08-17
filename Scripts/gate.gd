extends StaticBody2D

var bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bodies > 0:
		$AnimatedSprite2D.play("open_on")
		get_node("CollisionShape2D").disabled = true    # disable
	elif bodies <= 0:
		$AnimatedSprite2D.play("closed_on")
		get_node("CollisionShape2D").disabled = false   # enable



func _on_button_body_entered(body: Node2D) -> void:
	if !(body is StaticBody2D):
		bodies += 1



func _on_button_body_exited(body: Node2D) -> void:
	bodies -= 1
