extends RigidBody2D
class_name Pushbox

@export var DESTROY: bool = false:
	set(new_destroy):
		DESTROY = new_destroy;
		if new_destroy:
			$Powerable.TYPE = Constants.PowerableType.DESTROY;
		else:
			$Powerable.TYPE = Constants.PowerableType.NONE;
@export var STARTS_POWERED: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if STARTS_POWERED:
		$Powerable.set_power(STARTS_POWERED);
	if DESTROY == false:
		$Powerable.connect("power_changed", power);
		if STARTS_POWERED:
			$AnimatedSprite2D.play("non_breakable")
		else: 
			$AnimatedSprite2D.play("non_breakable_off")
	elif DESTROY == true:
		if STARTS_POWERED:
			$AnimatedSprite2D.play("breakable")
		else: 
			$AnimatedSprite2D.play("breakable_off")
	

func power(new_power: Constants.Power):
	if new_power == Constants.Power.ON:
		$AnimatedSprite2D.play("non_breakable")
	elif new_power == Constants.Power.OFF:
		$AnimatedSprite2D.play("non_breakable_off")

func die():
	$AnimatedSprite2D.play("breakable_fading")
	$AnimatedSprite2D.connect("animation_finished", queue_free)

func _on_area_2d_body_entered(body):
	body.pushing = false;

func _on_area_2d_body_exited(body):
	body.pushing = false;
