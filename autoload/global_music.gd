extends Node

var audio_stream_player := AudioStreamPlayer.new()

var loaded_stream_name: String = ""

var disabled: bool = true setget set_disabled

enum MUSIC_TITLES {
	FEEL_THE_LOVE,
	BEACH_WALK,
	ET_ALONE_ET_CALL_HOME,
	EIGHT_BIT_HEROS,
	SIMPLE_SIMPLYFIED,
	BEACHY_BEACH,
	LITTLE_GUITAR,
	RAIN,
	ARPY_ARP,
	FUN_IN_THE_SUN,
	WONDERFUL_LIE,
	LINES_OF_CODE,
	SOME_KIND_OF_MUSIC,
	BLUE_ARPEGGIO,
	GUITARS_AND_THINGS,
	ICELAND_THEME,
	PIRATOS_BETA,
}

const MUSIC_PATHS = {
	MUSIC_TITLES.FEEL_THE_LOVE: "res://world1/anttis_instrumentals_feel_the_love.ogg",
	MUSIC_TITLES.BEACH_WALK: "res://world1/anttis_instrumentals_beach_walk.mp3",
	MUSIC_TITLES.ET_ALONE_ET_CALL_HOME: "res://world1/anttis_instrumentals_ET_alone_ET_call_home_instrumental.mp3",
	MUSIC_TITLES.EIGHT_BIT_HEROS: "res://world1/daydream_anatomy_8_bit_heroes_03_nin10day_modified.ogg",
	MUSIC_TITLES.SIMPLE_SIMPLYFIED: "res://world2/anttis_instrumentals_simple_simplyfied.wav",
	MUSIC_TITLES.BEACHY_BEACH: "res://world2/anttis_instrumentals_beachy_beach.mp3",
	MUSIC_TITLES.LITTLE_GUITAR: "res://world2/anttis_instrumentals_little_guitar.mp3",
	MUSIC_TITLES.RAIN: "res://world3/anttis_instrumentals_rain.ogg",
	MUSIC_TITLES.ARPY_ARP: "res://world3/anttis_instrumentals_arpy_arp.wav",
	MUSIC_TITLES.FUN_IN_THE_SUN: "res://world3/anttis_instrumentals_fun_in the_sun.wav",
	MUSIC_TITLES.WONDERFUL_LIE: "res://world4/anttis_instrumentals_wonderful_lie.ogg",
	MUSIC_TITLES.LINES_OF_CODE: "res://world4/lines_of_code.mp3",
	MUSIC_TITLES.SOME_KIND_OF_MUSIC: "res://ui/anttis_instrumentals_some_kind_of_music.mp3",
	MUSIC_TITLES.BLUE_ARPEGGIO: "res://world_selector/anttis_instrumentals_blue_arpeggio.mp3",
	MUSIC_TITLES.GUITARS_AND_THINGS: "res://world_selector/anttis_instrumentals_guitars_and_things.mp3",
	MUSIC_TITLES.ICELAND_THEME: "res://world_selector/iceland_theme.mp3",
	MUSIC_TITLES.PIRATOS_BETA: "res://mobs/fernand/piratos_beta.mp3",
}

const LEVEL_STREAM_TITLES = {
	"0-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-5": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-2": MUSIC_TITLES.BEACH_WALK,
	"1-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-5": MUSIC_TITLES.ET_ALONE_ET_CALL_HOME,
	"1-6": MUSIC_TITLES.BEACH_WALK,
	"1-7": MUSIC_TITLES.EIGHT_BIT_HEROS,
	"1-8": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-9": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-0": MUSIC_TITLES.SIMPLE_SIMPLYFIED,
	"2-1": MUSIC_TITLES.SIMPLE_SIMPLYFIED,
	"2-2": MUSIC_TITLES.LITTLE_GUITAR,
	"2-3": MUSIC_TITLES.ET_ALONE_ET_CALL_HOME,
	"2-4": MUSIC_TITLES.BEACHY_BEACH,
	"2-5": MUSIC_TITLES.LITTLE_GUITAR,
	"2-6": MUSIC_TITLES.ET_ALONE_ET_CALL_HOME,
	"2-7": MUSIC_TITLES.BEACHY_BEACH,
	"2-8": MUSIC_TITLES.SIMPLE_SIMPLYFIED,
	"3-0": MUSIC_TITLES.RAIN,
	"3-1": MUSIC_TITLES.RAIN,
	"3-2": MUSIC_TITLES.ARPY_ARP,
	"3-3": MUSIC_TITLES.FUN_IN_THE_SUN,
	"3-4": MUSIC_TITLES.ARPY_ARP,
	"3-5": MUSIC_TITLES.ARPY_ARP,
	"3-6": MUSIC_TITLES.RAIN,
	"3-7": MUSIC_TITLES.ARPY_ARP,
	"3-8": MUSIC_TITLES.FUN_IN_THE_SUN,
	"3-9": MUSIC_TITLES.ARPY_ARP,
	"4-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-2": MUSIC_TITLES.WONDERFUL_LIE,
	"4-3": MUSIC_TITLES.WONDERFUL_LIE,
	"4-4": MUSIC_TITLES.WONDERFUL_LIE,
	"4-5": MUSIC_TITLES.WONDERFUL_LIE,
	"4-6": MUSIC_TITLES.WONDERFUL_LIE,
	"4-7": MUSIC_TITLES.WONDERFUL_LIE,
	"4-8": MUSIC_TITLES.WONDERFUL_LIE,
	"4-9": MUSIC_TITLES.WONDERFUL_LIE,
	"4-10": MUSIC_TITLES.WONDERFUL_LIE,
}

const LEVEL_STREAM_TITLES_SUBSECTION = {
	"0-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"0-5": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-5": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-6": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-7": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-8": MUSIC_TITLES.FEEL_THE_LOVE,
	"1-9": MUSIC_TITLES.ET_ALONE_ET_CALL_HOME,
	"2-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-3": MUSIC_TITLES.LITTLE_GUITAR,
	"2-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-5": MUSIC_TITLES.FEEL_THE_LOVE,
	"2-6": MUSIC_TITLES.ET_ALONE_ET_CALL_HOME,
	"2-7": MUSIC_TITLES.BEACHY_BEACH,
	"2-8": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-5": MUSIC_TITLES.FUN_IN_THE_SUN,
	"3-6": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-7": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-8": MUSIC_TITLES.FEEL_THE_LOVE,
	"3-9": MUSIC_TITLES.ARPY_ARP,
	"4-0": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-1": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-2": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-3": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-4": MUSIC_TITLES.FEEL_THE_LOVE,
	"4-5": MUSIC_TITLES.FEEL_THE_LOVE,
}


const MAIN_MENU_MUSIC = MUSIC_TITLES.SOME_KIND_OF_MUSIC

const WORLD_SELECTOR_TRACKS := [
	MUSIC_TITLES.BLUE_ARPEGGIO,
	MUSIC_TITLES.BLUE_ARPEGGIO,
	MUSIC_TITLES.GUITARS_AND_THINGS,
	MUSIC_TITLES.ICELAND_THEME,
	MUSIC_TITLES.BLUE_ARPEGGIO,
]


func _ready() -> void:
	var __: int
	pause_mode = PAUSE_MODE_PROCESS
	add_child(audio_stream_player, true)
	audio_stream_player.bus = "Music"
	__ = GlobalEvents.connect("level_changed", self, "_on_music_related_event")
	__ = GlobalEvents.connect("level_world_selector_loaded", self, "_on_music_related_event")
	__ = GlobalEvents.connect("level_subsection_changed", self, "_on_music_related_event")
	__ = GlobalEvents.connect("level_completed", self, "_on_music_related_event")
	__ = GlobalEvents.connect("player_died", self, "_on_music_related_event")
	__ = GlobalEvents.connect("story_boss_activated", self, "_on_music_related_event")
	#__ = GlobalEvents.connect("story_boss_level_end_completed", self, "_on_music_related_event")
	__ = GlobalEvents.connect("ui_pause_menu_return_prompt_yes_pressed", self, "_on_music_related_event")
	
	yield(GlobalEvents, "ui_faded")
	call_deferred("update_music")


func set_disabled(value: bool) -> void:
	disabled = value
	if disabled:
		audio_stream_player.stop()
		return
	call_deferred("update_music")


func _on_music_related_event(_a = null, _b = null) -> void:
	call_deferred("_sync_music_after_fade")
	
func _sync_music_after_fade() -> void:
	if GlobalUI.menu_locked:
		yield(GlobalEvents, "ui_faded")
		yield(get_tree(), "physics_frame") # optional, makes it land just after fade
	update_music()
	
func update_music() -> void:
	var new_track_name
	match Globals.game_state:
		Globals.GameStates.WORLD_SELECTOR:
			new_track_name = WORLD_SELECTOR_TRACKS[GlobalSave.get_stat("world_max")]
		Globals.GameStates.LEVEL:
			var level_key := "%d-%d" % [GlobalLevel.current_world, GlobalLevel.current_level]
			if GlobalLevel.in_subsection:
				new_track_name = LEVEL_STREAM_TITLES_SUBSECTION.get(level_key, MUSIC_TITLES.FEEL_THE_LOVE)
				
			else:
				new_track_name = LEVEL_STREAM_TITLES.get(level_key, MUSIC_TITLES.FEEL_THE_LOVE)

		Globals.GameStates.MENU:
			new_track_name = MAIN_MENU_MUSIC

	if GlobalLevel.in_boss:
		new_track_name = MUSIC_TITLES.PIRATOS_BETA

	var new_path_name = MUSIC_PATHS[new_track_name]
	
	if not new_path_name == loaded_stream_name:
		audio_stream_player.stream = load(new_path_name)
		loaded_stream_name = new_path_name

	if not audio_stream_player.playing:
		audio_stream_player.play()
