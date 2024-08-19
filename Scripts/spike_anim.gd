extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false;
	set_collision_mask_value(13, false);
	$AnimatedSprite2D.play("default")
	

func _on_powerable_power_changed(power: Constants.Power):
	if power == Constants.Power.ON:
		visible = true;
		set_collision_mask_value(13, true);
	else:
		visible = false;
		set_collision_mask_value(13, false);
		

func _on_body_entered(body):
	body.die();
