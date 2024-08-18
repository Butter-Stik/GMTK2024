extends StaticBody2D

var state: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state:
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("CollisionShape2D").disabled = false
		
	if $Powerable.power_state == Constants.Power.ON:
		if state:
			$AnimatedSprite2D.play("open_on")
		else:
			$AnimatedSprite2D.play("closed_on")
	else:
		if state:
			$AnimatedSprite2D.play("open_off")
		else:
			$AnimatedSprite2D.play("closed_off")

func on_trigger_state_changed(new_state: bool):
	print(new_state);
	state = new_state;
