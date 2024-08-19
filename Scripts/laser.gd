extends Node2D

@onready var beam_tip: Vector2 = $RayCast2D.target_position;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if $Head/Powerable.power_state == Constants.Power.ON:
		run_physics(delta);
	

func run_physics(_delta: float):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider();
		if collider is Player:
			collider.die();
		var point = ($RayCast2D.get_collision_point() - global_position).snapped(Vector2.ONE) * Vector2(1, 0);
		if beam_tip != point:
			beam_tip = point;
			$Beam.points[1] = beam_tip;
			$GPUParticles2D.position = beam_tip;

func _on_powerable_power_changed(power: Constants.Power):
	if power == Constants.Power.ON:
		$Beam.visible = true;
		$Head/AnimatedSprite2D.play("on");
		$Audio.play();
	else:
		$Beam.visible = false;
		$Head/AnimatedSprite2D.play("off");
