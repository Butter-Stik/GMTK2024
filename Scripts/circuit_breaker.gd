extends Area2D

var pulled: bool = false;
@export_file var f

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_powerable_power_changed(power: Constants.Power) -> void:
	if pulled == false:
		if $Powerable.power_state == Constants.Power.ON:
			$AnimatedSprite2D.play("not_pulled_on")
		else:
			$AnimatedSprite2D.play("not_pulled_off")


func _on_body_entered(body: Node2D) -> void:
	pulled = true;
	if pulled == true:
		$AnimatedSprite2D.play("pulled")
		get_tree().change_scene_to_file(f)
