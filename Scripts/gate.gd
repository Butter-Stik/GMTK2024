extends StaticBody2D

var state: bool = false:
	set(new_state):
		if new_state == state:
			return
		state = new_state;
		if new_state:
			set_collision_layer_value(1, false);
			$AnimatedSprite2D.play(\
				"open_on" \
				if $Powerable.power_state == Constants.Power.ON \
				else "open_off");
		else:
			set_collision_layer_value(1, true);
			$AnimatedSprite2D.play(\
				"closed_on" \
				if $Powerable.power_state == Constants.Power.ON \
				else "closed_off");

func on_trigger_state_changed(new_state: bool):
	print(new_state);
	state = new_state;

func _on_power_changed(power):
	if power == Constants.Power.ON:
		$AnimatedSprite2D.play("open_on" if state else "closed_on");
	else:
		$AnimatedSprite2D.play("open_off" if state else "closed_off");
