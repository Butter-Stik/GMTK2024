extends StaticBody2D

var state: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state:
		$AnimatedSprite2D.play("open_on")
		get_node("CollisionShape2D").disabled = true
	else:
		$AnimatedSprite2D.play("closed_on")
		get_node("CollisionShape2D").disabled = false

func on_trigger_state_changed(new_state: bool):
	print(new_state);
	state = new_state;
