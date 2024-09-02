class_name Player
extends Resource

@export var id := 0
@export var businesses := [] # {hood_index, extortion?: {by:enum(fam_1, fam_2), rate:float, owed:int}, laundering?: {by:enum(fam_1, fam_2), rate:float} }[]
@export var family_1_respect := 0.0
@export var family_2_respect := 0.0
@export var heat := 0.0
@export var job := -1 # hood_index
@export var loans := [] # {by:enum(fam_1, fam_2, bank), rate:float, owed:int}
@export var money := 0
@export var rentals := [] # hood_index[]
@export var sanity := 1.0
@export var street_smart := 0.0
@export var territories_respect := [] # range(-1, 1)[hood_index]
@export var past_four_triggers := []
@export var current_month := 0
@export var actions_left := 3
@export var months_jailed := 0
