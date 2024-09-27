extends Node

var music_playing = true
var background_music: AudioStreamPlayer2D
var masterVolume = 1
var musicVolume = 1
var sfxVolume = 1
var curr_scene = ""

@onready var button_order = ["mapMenu/map/map-level1", "mapMenu/map/map-level2", "mapMenu/map/map-level3", "mapMenu/map/map-level4"]
# Called when the node enters the scene tree for the first time
func _ready():
	background_music = $"background-music"
	background_music.play()
	update_level_access()
	congrats()

func _process(delta):
	$background.scroll_offset.x -= 60 * delta

# --------------------------------------------------------------
# Main Menu code
# --------------------------------------------------------------

# Start Button - Go to the Map and create the table
func _on_mainstart_btn_pressed():
	$"sound-effect".play()

	# Initialize the SQLite database object
	$mapMenu.visible = true
	$mainMenu.visible = false
	$descMenu.visible = false
	$insrMenu.visible = false
	$Control/SID.visible = false
	$Control/FirstName.visible = false
	$Control/LastName.visible = false
	$Control/Label.visible = false
	$Control/Label2.visible = false
	$Control/Label3.visible = false
	update_level_access()

# Options Button - Go to the option
func _on_mainoption_btn_pressed():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = false
	$descMenu.visible = false
	$insrMenu.visible = false

# Description Button
func _on_maindesc_btn_pressed():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = false
	$descMenu.visible = true
	$insrMenu.visible = false

func _on_maininsr_btn_pressed():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = false
	$descMenu.visible = false
	$insrMenu.visible = true

func _complete_game():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = false
	$descMenu.visible = true
	$"descMenu/desc/desc-title".hide()
	$"descMenu/desc/desc-content".hide()

# --------------------------------------------------------------
# Unlock levels and check game progress
# --------------------------------------------------------------

func update_level_access():
	# Unlock all levels
	for x in range(button_order.size()):
		get_node(button_order[x]).set_disabled(false)  # Unlock the level button
		get_node(button_order[x]).add_theme_color_override("font_color", "Green")  # Show the level as accessible

func congrats():
	# Check if all levels are completed
	for lvl in Global.pq_progress:
		if !lvl:
			return
	$finishMenu/confetti.play()
	$finishMenu/confetti2.play()
	$finishMenu/dolphin.play()
	$finishMenu.show()

# --------------------------------------------------------------
# Options code
# --------------------------------------------------------------

func _on_optionback_btn_pressed():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = true
	$descMenu.visible = false
	$insrMenu.visible = false

# Volume setup
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

# Master slider
func _on_master_value_changed(value):
	volume(0, value)
	masterVolume = value

# Music slider
func _on_music_value_changed(value):
	volume(1, value)
	musicVolume = value

# Sound fx slider
func _on_sfx_value_changed(value):
	volume(2, value)
	sfxVolume = value

# Mute toggles
func _on_optionmaster_box_toggled(toggled_on):
	if toggled_on:
		volume(0, 0)
	else:
		volume(0, masterVolume)

func _on_optionmusic_box_toggled(toggled_on):
	if toggled_on:
		volume(1, 0)
	else:
		volume(1, musicVolume)

func _on_optionsfx_box_toggled(toggled_on):
	if toggled_on:
		volume(2, 0)
	else:
		volume(2, sfxVolume)

# --------------------------------------------------------------
# Map code
# --------------------------------------------------------------

# Switch scene when a level button is pressed
func _on_mapbtn_pressed(level):
	$"sound-effect".play()
	var database = SQLite.new()
	database.path = "res://data.db"  # Specify the path to your SQLite database
	var db_opened = database.open_db()

	if db_opened:
		print("Opened database successfully (" + database.path + ")")
		
		# Create the players table if it doesn't exist
		var table = {
			"sid" : {"data_type": "text", "primary_key": true, "not_null": true},
			"first_name" : {"data_type": "text"},
			"last_name" : {"data_type": "text"},
			"current_level" : {"data_type": "text"},
			"score" : {"data_type": "int"}
		}
		database.create_table("players", table)
	else:
		print("Failed to open database!")

	# Get and print the current scene name
	var curr_scene = get_tree().current_scene.name
	print("Current scene: " + curr_scene)
	var data = {
		"sid" : $Control/SID.text,
		"first_name" : $Control/FirstName.text,
		"last_name" : $Control/LastName.text,
		"current_level" : curr_scene,
		"score" : null
	}
	database.insert_row("players", data)
	$mapMenu.visible = false
	$mainMenu.visible = false
	get_tree().change_scene_to_file("res://pq/" + level + ".tscn")

	

# Back Button: Go back to the main menu
func _on_mapback_btn_pressed():
	$"sound-effect".play()
	$mapMenu.visible = false
	$mainMenu.visible = true
	$descMenu.visible = false
	$insrMenu.visible = false
