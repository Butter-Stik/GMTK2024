extends CharacterBody2D
class_name Player
@export var SPEED = 75
@export var JUMP_VELOCITY = 200
@export var PUSH_SPEED = 30
var direction = 0
var speed = SPEED

func _physics_process(delta: float) -> void:
	# moved to function so it can be turned off more easily later
	var physics_info := Vector3.ZERO; # dummy value
	if $Powerable.power_state == Constants.Power.ON:
		physics_info = run_physics(delta)
	proc_anims(Vector2(physics_info.x, physics_info.y), physics_info.z)
	

func run_physics(delta: float) -> Vector3:
	# Add the gravity.
	var old_velocity := velocity;
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("restart"):
		die()
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("objects"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 17)
	move_and_slide()
	
	return Vector3(old_velocity.x, old_velocity.y, direction);

func proc_anims(old_velocity: Vector2, direction: float) -> void:
	# # debug messages
	# var animstate: String = $Sprite.animation;
	if $Powerable.power_state == Constants.Power.OFF:
		$Sprite.play("off");
	elif $Powerable.power_state == Constants.Power.BOOTING:
		$Sprite.play("awake");
	elif old_velocity.y * velocity.y < 0.0:
		$Sprite.play("apex");
	elif old_velocity.y != velocity.y and old_velocity.y == 0.0:
		$Sprite.play("launch");
	elif old_velocity.y != velocity.y and velocity.y == 0.0:
		$Sprite.play("land");
	elif velocity.y > 0.0:
		$Sprite.play("fall");
	elif velocity.y < 0.0:
		$Sprite.play("jump");
	elif direction != 0.0:
		$Sprite.flip_h = direction < 0.0;
		$Sprite.play("walk");
	else:
		$Sprite.play("idle");
	# # debug messages
	# if animstate != $Sprite.animation:
	# 	print($Sprite.animation);


func _on_spikes_body_entered(body: Node2D) -> void:
	if body is Player:
		die()
	

func die():
	get_tree().call_deferred("reload_current_scene");
	

func _on_box_body_entered(body: Node) -> void:
	if body is Player:
		speed = PUSH_SPEED
	

func _on_box_body_exited(body: Node) -> void:
	if body is Player:
		speed = SPEED
	

func _on_powerable_power_changed(power):
	if power == Constants.Power.OFF:
		call_deferred("proc_anims", Vector2.ZERO, 0.0);
