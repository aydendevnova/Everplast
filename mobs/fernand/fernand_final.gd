extends "res://mobs/fernand/fernand.gd"


func _ready() -> void:
	var __: int
	__ = GlobalEvents.connect("story_w3_fernand_anim_finished", self, "_story_w3_fernand_anim_finished")
	__ = mob_component.connect("died", self, "_died")
	__ = mob_component.connect("hit", self, "_hit")
	
	get_node("Position2D/Water Gun/EquippableBase").mode = 2
	yield(get_tree(), "physics_frame")
	
	mob_component.health = 350
	mob_component.max_health = 350
	shoot_speed = 1
	chase_speed = 200
	fly_speed = 100
	rng.seed = 99
	
	$"Position2D/Water Gun".queue_free()
	var gun = load("res://world_all/equippables/ice_gun.tscn").instance()
	$Position2D.add_child(gun, true)
	water_gun = gun.get_node("EquippableBase")
	water_gun.mode = 2
	$EnemyComponentManager/HurtArea.monitoring = false


func state_switching() -> void:
	var prev_state: int = state
	
	timer.start(rng.randf_range(0.5, 2))
	var new_state = rng.randi() % 3
	state = new_state
	
	while new_state == prev_state:
		new_state = rng.randi() % 3
		state = new_state
		yield(get_tree(), "physics_frame")
		
		
	# Endgame Fernand is always aggressive
	if state == States.FLY:
		state = States.SHOOT_PLAYER
		
	yield(timer, "timeout")
	state_switching()
	
func shoot_player_ai() -> void:
	var look_pos: Vector2 = get_node(GlobalPaths.PLAYER).global_position + Vector2(6, 6)
	var variation: float = rng.randf_range(-5, 5)
	look_pos.x += variation
	variation = rng.randf_range(-5, 5)
	
	look_pos.y += variation
	fake_pos.look_at(look_pos)
	current_speed *= shoot_speed
	
	update_gun_direction()
	
	if water_gun.may_fire:
		water_gun.fire()
		
func _died() -> void:
	if Globals.death_in_progress:
		return
		
	_play_death_effects()
	
	position_2d.queue_free()
	
	get_tree().call_group("Cannon", "disable")
	get_tree().call_group("Snowball", "destroy")
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	get_tree().paused = true
	
	var dialog_lines := [
		"fernand.final_defeat_1", "fernand.final_defeat_2", "fernand.final_defeat_3",
		"fernand.final_defeat_4", "fernand.final_defeat_5", "fernand.final_defeat_6",
		"fernand.final_defeat_7", "fernand.final_defeat_8", "fernand.final_defeat_9",
		"fernand.final_defeat_10", "fernand.final_defeat_11", "fernand.final_defeat_12",
		"fernand.final_defeat_13",
	]
	
	for key in dialog_lines:
		GlobalEvents.emit_signal("ui_dialogued", tr(key), NAME)
		
	yield(get_tree(), "physics_frame")
	
	get_tree().paused = true
	
	yield(GlobalEvents, "ui_dialogue_hidden")
	GlobalEvents.emit_signal("save_file_saved", true)
	GlobalEvents.emit_signal("story_fernand_beat")
	
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	queue_free()
	
func _story_w3_fernand_anim_finished() -> void:
	active = true
	state_switching()
