extends Node

const BOSS_RANK_MAP := {
	GlobalStats.Bosses.FERNAND: GlobalStats.Ranks.GOLD,
	GlobalStats.Bosses.OSTRICH: GlobalStats.Ranks.DIAMOND
}

func _ready() -> void:
	var __: int
	__ = GlobalEvents.connect("story_boss_killed", self, "_story_boss_killed")
	__ = GlobalEvents.connect("story_w3_attempt_beat", self, "_story_w3_attempt_beat")


func _story_boss_killed(idx: int) -> void:
	run_boss_defeat_sequence(idx)
	
func run_boss_defeat_sequence(idx: int) -> void:
	GlobalUI.menu = GlobalUI.Menus.CUTSCENE
	
	# Kill snowballs, disable cannons
	get_tree().call_group("Cannon", "disable")
	get_tree().call_group("Snowball", "destroy")
	# 1 Wait for dialog to finish
	yield(GlobalEvents, "ui_dialogue_hidden")
	GlobalUI.menu_locked = true
	get_tree().paused = true

	# 2 Spawn rank pickup if before world 3
	_try_spawn_rank_pickup(idx)

	# 3 Fade out
	var fade_player: FadePlayer = get_node(GlobalPaths.FADE_PLAYER)
	fade_player.transition()
	yield(GlobalEvents, "ui_faded")
	
	# 4 Boss Cam Cutscene
	var boss_camera: Camera2D = get_node(GlobalPaths.LEVEL + "/BossComplete")
	boss_camera.current = true
	boss_camera.play_cutscene()
	yield(boss_camera, "cutscene_finished")
	boss_camera.set_trauma(0.4)
	
	# 5 Level-end teleporter sequence
	var teleporter = get_node(GlobalPaths.LEVEL + "/LevelComponents/LevelEndTeleporter")
	teleporter.appear()
	yield(teleporter, "appeared")
	
	# 6 Fade back in
	fade_player.transition()
	yield(GlobalEvents, "ui_faded")
	
	# 7 Restore player's control
	GlobalUI.menu = GlobalUI.Menus.NONE
	GlobalLevel.in_boss = false
	get_tree().paused = false
	get_node(GlobalPaths.PLAYER_CAMERA).current = true
	GlobalUI.menu_locked = false
	
	GlobalEvents.emit_signal("story_boss_sequence_completed", idx)
	

func _try_spawn_rank_pickup(idx: int) -> void:
	if int(GlobalSave.get_stat("world_max")) >= 3:
		return
		
	if not BOSS_RANK_MAP.has(idx):
		return
		
	var rank_pickup = load(GlobalPaths.RANK_PICKUP).instance()
	rank_pickup.rank = BOSS_RANK_MAP[idx]

	get_node(GlobalPaths.LEVEL).add_child(rank_pickup)
	rank_pickup.global_position = get_node(GlobalPaths.LEVEL + "/LevelComponents/RankPickup").global_position


func _story_boss_level_end_completed(_idx: int) -> void:
	yield(GlobalEvents, "ui_faded")
	GlobalUI.menu = GlobalUI.Menus.NONE
	GlobalLevel.in_boss = false
	get_tree().paused = false
	get_node(GlobalPaths.PLAYER_CAMERA).current = true
	GlobalUI.menu_locked = false


func _story_w3_attempt_beat() -> void:
	GlobalEvents.emit_signal("ui_dialogued", tr("fernand.reentry_1"), "Fernand")
	GlobalEvents.emit_signal("ui_dialogued", tr("fernand_reentry_2"), "Fernand")
