extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	

func _on_powerable_power_changed(power: Constants.Power):
	if power == Constants.Power.ON:
		visible = true;
		$CollisionShape2D.set_deferred("disabled", false);
	else:
		visible = false;
		$CollisionShape2D.set_deferred("disabled", true);
		

func _on_body_entered(body):
	body.die();
