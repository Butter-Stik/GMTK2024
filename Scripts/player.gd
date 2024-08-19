extends CharacterBody2D
class_name Player
@export var SPEED = 60
@export var JUMP_VELOCITY = 200
@export var PUSH_SPEED = 30
var direction = 0
var speed = SPEED
var pushing = false:
	set(new_pushing):
		pushing = new_pushing;
		if new_pushing:
			speed = PUSH_SPEED;
		else:
			speed = SPEED;
var dying = false;

var audio_state: AudioState = AudioState.IDLE:
	set(new_state):
		if new_state == audio_state:
			return;
		audio_state = new_state;
		match new_state:
			AudioState.IDLE:
				play_sfx("idle");
			AudioState.JUMP:
				play_sfx("jump");
			AudioState.WALK:
				play_sfx("walk");
			AudioState.LAND:
				play_sfx("land");

enum AudioState {
	WALK,
	JUMP,
	LAND,
	IDLE
}

func _physics_process(delta: float) -> void:
	if dying:
		return
	
	var physics_info := Vector3.ZERO; # dummy value
	if Input.is_action_just_pressed("restart"):
		die()
	if $Powerable.power_state == Constants.Power.ON:
		physics_info = run_physics(delta)
		$"/root/Death".set_circle_position(global_position);
	proc_anims(Vector2(physics_info.x, physics_info.y), physics_info.z)
	

func run_physics(delta: float) -> Vector3:
	# Add the gravity.
	var old_velocity := velocity;
	if not is_on_floor():
		velocity += get_gravity() * delta
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
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("objects"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 17)
	move_and_slide()
	
	return Vector3(old_velocity.x, old_velocity.y, direction);

func proc_anims(old_velocity: Vector2, direction: float) -> void:
	# # debug messages
	# var animstate: String = $Sprite.animation;
	if $Powerable.power_state == Constants.Power.OFF:
		$Sprite.play("off");
		audio_state = AudioState.IDLE;
	elif $Powerable.power_state == Constants.Power.BOOTING:
		$Sprite.play("awake");
		audio_state = AudioState.IDLE;
	elif old_velocity.y * velocity.y < 0.0:
		$Sprite.play("apex");
		audio_state = AudioState.IDLE;
	elif old_velocity.y != velocity.y and old_velocity.y == 0.0:
		$Sprite.play("launch");
		audio_state = AudioState.JUMP;
	elif old_velocity.y != velocity.y and velocity.y == 0.0:
		$Sprite.play("land");
		audio_state = AudioState.LAND;
	elif velocity.y > 0.0:
		$Sprite.play("fall");
		audio_state = AudioState.IDLE;
	elif velocity.y < 0.0:
		$Sprite.play("jump");
		audio_state = AudioState.IDLE;
	elif direction != 0.0:
		$Sprite.flip_h = direction < 0.0;
		$Sprite.play("walk");
		audio_state = AudioState.WALK;
	else:
		$Sprite.play("idle");
		audio_state = AudioState.IDLE;
	# # debug messages
	# if animstate != $Sprite.animation:
	# 	print($Sprite.animation);

func play_sfx(name: String):
	if !$Feet.playing:
		$Feet.play();
	($Feet.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip_by_name(name);

func _on_spikes_body_entered(body: Node2D) -> void:
	if body is Player:
		die()
	

func die():
	$"/root/Death".play();
	dying = true;
	$Sprite.set_deferred("speed_scale", 0.5);
	$Sprite.call_deferred("play", "death");
	#get_tree().call_deferred("reload_current_scene");
	

func _on_powerable_power_changed(power):
	if power == Constants.Power.OFF:
		call_deferred("proc_anims", Vector2.ZERO, 0.0);

func _on_feet_finished():
	return
	match audio_state:
		AudioState.IDLE:
			pass
		AudioState.WALK:
			print("here");
			$Feet.play();
		AudioState.LAND:
			audio_state = AudioState.IDLE;
