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
		$AnimatedSprite2D.play("non_breakable")
	elif DESTROY == true:
		$AnimatedSprite2D.play("breakable")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func die():
	queue_free();
