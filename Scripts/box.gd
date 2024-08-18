extends RigidBody2D
class_name Pushbox

@export var DESTROY: bool = false:
	set(new_destroy):
		DESTROY = new_destroy;
		if new_destroy:
			$Powerable.TYPE = Constants.PowerableType.DESTROY;
		else:
			$Powerable.TYPE = Constants.PowerableType.NONE;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DESTROY == false:
		$Powerable.connect("power_changed", power);
		$AnimatedSprite2D.play("non_breakable")
	elif DESTROY == true:
		$AnimatedSprite2D.play("breakable")

func power(new_power: Constants.Power):
	if new_power == Constants.Power.ON:
		$AnimatedSprite2D.play("non_breakable")
	elif new_power == Constants.Power.OFF:
		$AnimatedSprite2D.play("non_breakable_off")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func die():
	$AnimatedSprite2D.play("breakable_fading")
	$AnimatedSprite2D.connect("animation_finished", queue_free)

func _on_area_2d_body_entered(body):
	body.pushing = false;

func _on_area_2d_body_exited(body):
	body.pushing = false;
