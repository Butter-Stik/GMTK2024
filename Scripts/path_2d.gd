extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AnimatableBody2D/Powerable.power_state == Constants.Power.ON:
		path.progress += speed * delta


func _on_powerable_power_changed(power: Constants.Power) -> void:
	if $AnimatableBody2D/Powerable.power_state == Constants.Power.ON:
		$AnimatableBody2D/AnimatedSprite2D.play("on")
	else:
		$AnimatableBody2D/AnimatedSprite2D.play("off")
