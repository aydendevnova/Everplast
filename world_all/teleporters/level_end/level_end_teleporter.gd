extends Area2D

signal appeared()

export var world: int = 0
export var level: int = 0
export var hide_shader: bool = false
export var is_endgame_teleporter: bool = false

var with_player := false
var used := false

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_player_glow: AnimationPlayer = $AnimationPlayerGlow
onready var appear_sound: AudioStreamPlayer = $AppearSound
onready var sound: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	var __: int
	__ = connect("body_entered", self, "_body_entered")
	__ = connect("body_exited", self, "_body_exited")
	
	$Godrays.show()
	if hide_shader:
		$Godrays.hide()


func _input(event: InputEvent) -> void:
	if not visible: return

	if not event.is_action_pressed("interact"):
		return
		
	if not with_player or GlobalUI.menu_locked or used:
		return


	if is_endgame_teleporter:
		_use_endgame()
	else:
		_use_normal()


func _use_normal():
	GlobalUI.menu_locked = true
	GlobalInput.start_ultra_high_vibration()
	used = true
	anim_player.play("hide")
	sound.play()
	GlobalEvents.emit_signal("level_complete_started")

	get_tree().paused = true

	while anim_player.is_playing():
		get_node(GlobalPaths.PLAYER_CAMERA).set_trauma(0.2)
		yield(get_tree(), "physics_frame")

	GlobalEvents.emit_signal("level_completed")

func _use_endgame():
	$VisibilityEnabler2D.queue_free()
	$Particles.emitting = true
	$AudioStreamPlayer.play()
	GlobalInput.start_ultra_high_vibration()
	used = true
	anim_player.play("explode")
	get_node(GlobalPaths.PLAYER_CAMERA).set_trauma(0.2)

	while anim_player.is_playing():
		yield(get_tree(), "physics_frame")

	for i in 20:
		yield(get_tree(), "physics_frame")

	GlobalEvents.emit_signal("story_w3_attempt_beat")
	return


func appear() -> void:
	
	anim_player.play("appear")
	yield(get_tree(), "physics_frame")
	show()
	modulate = Color8(255, 255, 255, 255)
	appear_sound.play()
	yield(anim_player, "animation_finished")
	emit_signal("appeared")


func _body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		with_player = true
		anim_player_glow.play("glow")
		GlobalInput.interact_activators += 1


func _body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		with_player = false
		anim_player_glow.play_backwards("glow")
		GlobalInput.interact_activators -= 1
