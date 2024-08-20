extends Resource;
class_name ScreenShake;

@export var decay: float = 0.8;
@export var max_displacement: Vector2 = Vector2(18, 10);
@export var max_rotation: float = 0.2;
@export var noise: FastNoiseLite;

var noise_y: float = 0;

var trauma: float = 0.0;

func add_trauma(amount: float):
	trauma = min(trauma + amount, 1);

func set_trauma(amount: float):
	trauma = min(amount, 1);

func feed(delta: float, do_decay: bool) -> Vector3:
	var offset_and_rot: Vector3 = Vector3.ZERO;
	if trauma > 0:
		if do_decay:
			trauma = max(trauma - decay * delta, 0);
		noise_y += 1;
		var intensity = pow(trauma, 3);
		offset_and_rot.z = max_rotation * intensity * noise.get_noise_2d(noise.seed, noise_y);
		offset_and_rot.x = max_displacement.x * intensity * noise.get_noise_2d(noise.seed * 2, noise_y);
		offset_and_rot.y = max_displacement.y * intensity * noise.get_noise_2d(noise.seed * 3, noise_y);
	return offset_and_rot;
