extends Node
var curr_scene = ""
var correct_dict = {
	"K⁺  Cl⁻": "AgF",  # problem 1
	"Na⁺  C₂O₄²⁻": "CaCl₂",  # problem 2
	"K⁺  F⁻": "MgSO₄",  # problem 3
	"Al³⁺  Cl⁻": "NaOH",  # problem 4
	"Na⁺  CO₃²⁻": "CaO",  # 5
	"Pb²⁺  NO₂⁻": "Na₃PO₄",  # 6
	"Ca²⁺  Br⁻": "K₂CO₃",  # 7
	#"KNO3": "help",  # 8 - no solution
	"Fe²⁺  Cl⁻": "NaOH",  # 9
	"Na⁺  PO₄³⁻": "CaCl₂",  # 10
	"K⁺  AsO₄³⁻": "FeCl₂",  # 11
	"Cd²⁺  SO₄²⁻": "Na₂S",  # 12
	"Cr³⁺  SCN⁻": "NaOH",  # 13
	#"LiClO4": "help",  # 14 - no solution
	"Ag⁺  NO₃⁻": "NaCl",  # 15
	"K⁺  CrO₄²⁻": "BaCl₂",  # 16
	"Na⁺  PO₄³⁻  OH⁻": "Ca(NO₃)₂",  # 17 ?
	"Na⁺  AsO₄³⁻ OH⁻": "CuCl₂",  # 18 ?
	"Hg²⁺  Cl⁻": "K₂S",  # 19
	"Hg₂²⁺  NO₃⁻": "Na₂CO₃"  # 20
}

var problem_dict = {
	"K⁺  Cl⁻": ["AgF", "AgBr", "MgCO₃"],  # problem 1
	"Na⁺  C₂O₄²⁻": ["CaCl₂", "CaSO₄", "KCl"],  # problem 2
	"K⁺  F⁻": ["MgSO₄", "CuS", "Ca₃(PO₄)₂"],  # problem 3
	"Al³⁺  Cl⁻": ["NaOH", "Ba₃(PO₄)₂", "KClO₃"],  # problem 4
	"Na⁺  CO₃²⁻": ["CaO", "NH₄I", "Fe(OH)₃"],  # 5
	"Pb²⁺  NO₂⁻": ["Na₃PO₄", "Zn(ClO₄)₂", "NiS"],  # 6
	"Ca²⁺  Br⁻": ["K₂CO₃", "MgCl₂", "NH₄C₂H₃O₂"],  # 7
	#"KNO3": ["FeCl3", "Al2(SO4)3", "Ag2CO3"],  # 8 - no solution
	"Fe²⁺  Cl⁻": ["NaOH", "KSCN", "LiC₂H₃O₂"],  # 9
	"Na⁺  PO₄³⁻": ["CaCl₂", "NH₄F", "KI"],  # 10
	"K⁺  AsO₄³⁻": ["FeCl₂", "NaBr", "KF"],  # 11
	"Cd²⁺  SO₄²⁻": ["Na₂S", "NaC₂H₃O₂", "K₂SO₄"],  # 12
	"Cr³⁺  SCN⁻": ["NaOH", "KClO₄", "Na₂SO₄"],  # 13
	#"LiClO4": ["CuO", "AlBr3", "Ca(OH)2"],  # 14 - no solution
	"Ag⁺  NO₃⁻": ["NaCl", "KF", "Ca(ClO₄)₂"],  # 15
	"K⁺  CrO₄²⁻": ["BaCl₂", "KCl", "LiBr"],  # 16
	"Na⁺  PO₄³⁻  OH⁻": ["Ca(NO₃)₂", "NaOH", "KBr"],  # 17 ?
	"Na⁺  AsO₄³⁻ OH⁻": ["CuCl₂", "KC₂H₃O₂", "NaI"],  # 18 ?
	"Hg²⁺  Cl⁻": ["K₂S", "KBr", "NaCl"],  # 19
	"Hg₂²⁺  NO₃⁻": ["Na₂CO₃", "KClO₄", "LiNO₃"]  # 20
}

var problem_options = correct_dict.keys()

func flask_throw(puddle_key, phial_compound):
	if phial_compound == correct_dict[puddle_key]:
		get_parent().correct()
		# update buttons and puddle
	else:
		get_parent().incorrect()
		shuffle_and_update(puddle_key)

func shuffle_and_update(puddle_key):
	# Shuffle the options if the player is incorrect
	var randomList = problem_dict[puddle_key]
	randomList.shuffle()
	get_parent().button_options = randomList
	get_parent().call("updateText")

func startGameText():
	curr_scene = get_tree().current_scene.name
	if(curr_scene != "level1"):
		var randomIndex = randi() % problem_options.size()
		var randomKey = problem_options[randomIndex]
		problem_options.remove_at(randomIndex)
		var randomList = problem_dict[randomKey]
		get_parent().puddle = randomKey
		randomList.shuffle()
		get_parent().button_options = randomList
		get_parent().call("updateText")
