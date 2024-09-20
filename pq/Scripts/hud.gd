extends CanvasLayer

var button_options = ["", "", ""]
var puddle = ""
var curr_scene = ""
var health_var = 3
var points = 0
var is_help_active = false
var points_needed = 0  # Variable to hold points needed for level completion

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_scene = get_tree().current_scene.name
	match curr_scene:
		"level1":
			points_needed = 25
		"level2":
			points_needed = 50
		"level3":
			points_needed = 75
		"level4":
			points_needed = 100  # Set points needed for level 4
	$ScienceScript.startGameText()
	updateText()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateText():
	$Flasks/FlaskHolder/Option1.text = button_options[0]
	$Flasks/FlaskHolder/Option2.text = button_options[1]
	$Flasks/FlaskHolder/Option3.text = button_options[2]
	$Puddle.text = puddle

func _on_chem_button_pressed(button):
	if ($PauseButton.button_pressed):
		print("Disabling throw function while hints are being shown")
		# show_hints(hint_dict[puddle])
	elif is_help_active:
		print("Disabling throw function while hints are being shown")
		return
	else:
		$Flasks.hide()
		# If textbox is inactive meaning player is playing, throw the chemical
		get_tree().call_group("flask_reactions", "flask_throw")
		$ScienceScript.flask_throw(puddle, button_options[button])
		$HelpButton/SolubilityChart.hide()
		$HelpButton/SolubilityKey.hide()
		$PauseButton.show()
		$Health.show()
		$PointsLabel.show()
		$Textbox.hide()

func incorrect():
	$wrong.play()
	await get_tree().create_timer(2).timeout
	health_var -= 1
	$Health.get_children()[health_var].hide()
	$Textbox.visible = true
	$Textbox/TextboxScript.update_dolphin_textbox("Make sure that you add a soluble ionic compound so that the ions are free to react.")
	$Textbox/TextboxContainer.visible = true
	if (health_var == 0):
		$Flasks.hide()
		$PauseButton.hide()
		$Puddle.hide()
		$PointsLabel.hide()
		$Retry.show()
		$ExitButton.show()
	else:
		$Flasks.show()

func correct():
	var points_increment = 5
	points += points_increment  # Increment global points
	print(points)
	$PointsLabel.text = "Points : " + str(points)
	
	$correct.play()
	await get_tree().create_timer(2).timeout
	get_tree().call_group("flask_reactions", "success")
	await get_tree().create_timer(3).timeout
	
	if points < points_needed:
		$Health.hide()
		self.hide()
		$ScienceScript.startGameText()
		if curr_scene != "level3":
			get_tree().call_group("flask_reactions", "_walk")
			get_tree().call_group("flask_reactions", "move_forward")
			await get_tree().create_timer(2).timeout
			get_tree().call_group("flask_reactions", "_stop")
		get_parent().question_number += 1
		self.show()
		$Health.show()
		$Flasks.show()
	else:
		# If points or progress exceeds the threshold
		print("YES!")
		match curr_scene:
			"level1":
				Global.pq_progress[0] = true
			"level2":
				Global.pq_progress[1] = true
			"level3":
				Global.pq_progress[2] = true
			"level4":
				Global.pq_progress[3] = true  # Track progress for level 4
		_on_exit_button_pressed()
		$Flasks.show()

func _on_pause_button_toggled(toggled_on):
	$ExitButton.visible = toggled_on
	$Health.visible = !toggled_on
	$PointsLabel.visible = !toggled_on
	$Textbox.visible = toggled_on
	$Flasks.visible = !toggled_on
	$HelpButton.visible = !toggled_on
	$Puddle.visible = !toggled_on

func _on_help_button_toggled(toggled_on):
	is_help_active = toggled_on
	$HelpButton.visible = true
	$PauseButton.visible = !toggled_on
	$ExitButton.visible = false
	#$HelpButton/SolubilityChart.visible = toggled_on
	#$HelpButton/SolubilityKey.visible = toggled_on
	$Health.visible = !toggled_on
	$PointsLabel.visible = !toggled_on
	$Textbox.visible = toggled_on
	$Textbox/TextboxScript.update_dolphin_textbox(hint_dict[puddle])
	$Textbox/TextboxContainer.visible = toggled_on
	

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res:///pq/Menu/main_menu.tscn")


##function to show hint for individual flask button pressed
#func show_hints(compound):
	#if (compound == "Hg2(NO3)2"):
		#$Textbox/TextboxScript.update_dolphin_textbox("Hg2(NO3)2")
	#elif (compound == "AgBr"):
		#$Textbox/TextboxScript.update_dolphin_textbox("AgBr")
	#elif (compound ==  "MgCO3"):
		#$Textbox/TextboxScript.update_dolphin_textbox("MgCO3")

var hint_dict = {
	"K⁺  Cl⁻": "You are measuring the chemical oxygen demand of a wastewater sample. Chloride ions interfere with the analysis. Choose a soluble ionic compound to add that will precipitate out the chloride ion.",
	"Na⁺  C₂O₄²⁻": "Oxalate ions are found in food and beverages such as soft drinks. They form kidney stones. Choose the soluble ionic compound that will form a solid with the oxalate ion.",
	"K⁺  F⁻": "Fluoride is naturally found in some water. Too much of it causes skeletal fluorosis. Choose the soluble ionic compound that you can add to remove fluoride from water.",
	"Al³⁺  Cl⁻": "The aluminum ion is toxic to plants. It also precipitates out on fish gills and suffocates them. Choose that soluble ionic compound that you can add to remove aluminum ions from water.",
	"Na⁺  CO₃²⁻": "In water treatment, a protective coating is intentionally formed over iron and lead pipes to reduce iron and lead ions in water. Choose the soluble ionic compound that you could add to water to form a protective coating on pipes with the carbonate ion.",
	"Pb²⁺  NO₂⁻": "Your town has lead ions in its water. Choose the soluble ionic compound that can be added to precipitate the lead ions out of the water.",
	"Ca²⁺  Br⁻": "Your community has hard water caused by calcium and magnesium ions in the water. Hard water causes several issues such as soap scum formation. Choose the soluble ionic compound that you could add to soften the water.",
	#"KNO3": "Your house has its own well. Fertilizer applied nearby has been converted into nitrate through the nitrogen cycles. The concentration of nitrate ion in your well is high, which can lead to adverse health effects. Choose the soluble ionic compound to add to remove the nitrate from your well water.",
	"Fe²⁺  Cl⁻": "You drink well water that contains Fe2+ ions. When the water is exposed to air, Fe2+ is oxidized to Fe3+. Fe3+ then forms a rust-colored precipitate. Choose the soluble ionic compound to add to form this rust colored precipitate.",
	"Na⁺  PO₄³⁻": "Phosphate is used as a fertilizer on farms, lawns, golf courses etc. Some of the phosphate ends up in lakes, contributing to harmful algal blooms. Choose the soluble ionic compound to add to your lake to remove phosphate ions from the water.",
	"K⁺  AsO₄³⁻": "Arsenate is found in minerals and can make its way into groundwater and be carcinogenic. Choose the soluble ionic compound that you can add to your water supply to remove the arsenate ion as a solid.",
	"Cd²⁺  SO₄²⁻": "Cadmium is a toxic heavy metal that can be found in drinking water. Choose the soluble ionic compound that you can add to your water supply to remove cadmium ions.",
	"Cr³⁺  SCN⁻": "Chromium is a toxic heavy metal that can be found in drinking water. Choose the soluble ionic compound that you can add to your water supply to remove chromium ions.",
	#"LiClO4": "The perchlorate ion is used in explosives such as fireworks and in military applications. Due to negative health effects, perchlorate is limited to 10 µg/L in drinking water. Since all perchlorates are soluble, it is difficult to remove. It must be removed with a method other than precipitation.",
	"Ag⁺  NO₃⁻": "You want to measure the concentration of chloride ions in a urine sample as part of a research project. One way to measure the concentration of chloride ion involves turning it into a solid ionic compound. Choose the soluble ionic compound that you can add to form a solid with chloride ions.",
	"K⁺  CrO₄²⁻": "Chromium is a toxic heavy metal that can be found in drinking water. Choose the soluble ionic compound that you can add to your water supply to remove cadmium ions.",
	"Na⁺  PO₄³⁻  OH⁻": "Tooth enamel and bone are ionic compounds. Choose the soluble ionic compound that you could add to form tooth enamel.",
	"Na⁺  AsO₄³⁻ OH⁻": "Clinoclase is a mineral composed of an insoluble ionic compound that forms in nature by precipitation reactions. Choose the soluble ionic compound that you can add to form Clinoclase.",
	"Hg²⁺  Cl⁻": "Mercury is a toxic heavy metal that cycles through the environment. It is found in minerals and is released into the environment through both natural and anthropogenic processes. Mercury (II) is the monatomic ion form. Choose the soluble ionic compound that you can add to remove mercury (II) ions from water.",
	"Hg₂²⁺  NO₃⁻": "Mercury (I) is the polyatomic ion form of mercury. Like mercury (II), it can be removed from water using precipitation reactions. Choose the soluble ionic compound that you can add to remove mercury (I) ions from water."
}

#var tutorial_dict = {
	#"tutorial" : "Welcome to the Ocean Lab tutorial. Press the flask button to throw a phial",
	#"phial": "When this button is pressed, the player throws a phial hoping to form a precipitate in the puddle. Now press the pause button.",
	#"speaker": "Fancy some music? Toggle it on and off with this button",
	#"help": "this button's functionality is under construction",
	#"exit" : "press the exit button if you are ready",
	#"pause" : "Pausing shows a hint! The help button shows a solubility table. (Finding tables online may be needed). You can exit now.",
	#"play" : "press play when you are ready to throw the phial"
#}


func _on_chart_pressed(toggled_on):
	$HelpButton/SolubilityChart.visible = toggled_on
	$HelpButton/SolubilityKey.visible = toggled_on
