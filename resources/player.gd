class_name Player
extends Resource

@export var id := 0
@export var businesses := [] # {territory_index, extortioner?: enum(fam_1, fam_2)}[]
@export var family_1_respect := 0.0
@export var family_2_respect := 0.0
@export var heat := 0.0
@export var job: Dictionary # {territory_index}
@export var loans := []
@export var money := 0
@export var rentals := [] # {territory_index}[]
@export var sanity := 1.0
@export var street_smart := 0.0
@export var territories_respect := [] # range(-1, 1)[territory_index]
@export var past_four_triggers := []
@export var current_month := 0
@export var actions_left := 3
