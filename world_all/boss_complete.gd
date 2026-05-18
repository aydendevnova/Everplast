extends Camera2D

signal cutscene_finished()

const MAX_OFFSET := Vector2(10000, 7500)

const DECAY: float = 0.8
const MAX_ROLL: float = 0.1

var trauma: float = 0.0
var trauma_power: float = 4.5
var noise_y: int = 0

onready var noise := OpenSimplexNoise.new()
onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	zoom = Vector2(0.21875, 0.21875)


func add_trauma(amount) -> void:
	trauma = min(trauma + amount, 1.0)

func set_trauma(amount) -> void:
	trauma = min(amount, 1.0)


func _process(delta) -> void:
	if trauma:
		trauma = max(trauma - DECAY * delta, 0)
		shake()


func shake() -> void:
	var amount = pow(trauma, trauma_power)

	noise_y += 1

	rotation = MAX_ROLL * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = MAX_OFFSET.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = MAX_OFFSET.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)


func play_cutscene() -> void:
	anim_player.play("cutscene")
	yield(anim_player, "animation_finished")
	emit_signal("cutscene_finished")
