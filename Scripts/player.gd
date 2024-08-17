extends CharacterBody2D
class_name Player
@export var SPEED = 75
@export var JUMP_VELOCITY = 200
@export var PUSH_SPEED = 50
var direction = 0

func _physics_process(delta: float) -> void:
	# moved to function so it can be turned off more easily later
	var old_velocity := Vector2.ZERO; # dummy value
	if $Powerable.power_state == Constants.Power.ON:
		old_velocity = run_physics(delta)
	
	

func run_physics(delta: float) -> Vector2:
	# Add the gravity.
	var old_velocity := velocity;
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		print(velocity.y);

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	proc_anims(old_velocity, direction);
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("objects"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 30)
			if abs(velocity.x) < SPEED+5:
				velocity.x = direction * PUSH_SPEED
	
	move_and_slide()
	
	
	return old_velocity;

func proc_anims(old_velocity: Vector2, direction: int) -> void:
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
	pass # Replace with function body.
	
func die():
	get_tree().reload_current_scene()
	pass
