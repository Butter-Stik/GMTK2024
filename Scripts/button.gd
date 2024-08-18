extends Area2D

signal state_changed(pressed: bool);

var queued_bodies = 0;
var bodies = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $StaticBody2D/Powerable.power_state == Constants.Power.ON:
		run_physics(delta);

func run_physics(_delta: float) -> void:
	if queued_bodies != 0:
		print("changing")
		if bodies == 0:
			state_changed.emit(true);
		elif bodies + queued_bodies == 0:
			state_changed.emit(false);
	bodies += queued_bodies;
	queued_bodies = 0;
	if bodies > 0:
		$AnimatedSprite2D.play("pushed_on")
	elif bodies <= 0:
		$AnimatedSprite2D.play("unpushed_on")


func _on_body_entered(body: Node2D) -> void:
	if body is not StaticBody2D:
		queued_bodies += 1
		print(queued_bodies)


func _on_body_exited(body: Node2D) -> void:
	queued_bodies -= 1
