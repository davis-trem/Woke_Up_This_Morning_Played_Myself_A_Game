class_name SaveGame
extends Resource

const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')

const SAVE_GAME_PATH = 'user://save.tres'

@export var version = 1
@export var player: Player
@export var neighoborhood_stats_list: Array[NeighborhoodStats] = []

func write_savegame():
	ResourceSaver.save(self, SAVE_GAME_PATH)


static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)


static func load_savegame() -> SaveGame:
	return ResourceLoader.load(SAVE_GAME_PATH, '', ResourceLoader.CACHE_MODE_IGNORE)

