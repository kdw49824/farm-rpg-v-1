class_name HitComponent
extends Area2D
## Component that handles dealing damage/interaction with HurtComponents
## Attach to the player or any entity that can interact with the environment

@export_group("Tool Settings")
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage: int = 1

# Cache overlapping bodies to avoid repeated lookups
var _cached_overlaps: Array[Node2D] = []
var _cache_valid: bool = false


func _ready() -> void:
	# Connect area signals for cache management
	area_entered.connect(_on_area_cache_changed)
	area_exited.connect(_on_area_cache_changed)
	body_entered.connect(_on_body_cache_changed)
	body_exited.connect(_on_body_cache_changed)


## Main hit function - called when tool is used
func try_hit() -> void:
	match current_tool:
		DataTypes.Tools.AxeWood, DataTypes.Tools.AxeStone, DataTypes.Tools.AxeIron:
			_axe_hit()
		DataTypes.Tools.TillGround:
			_till_hit()
		DataTypes.Tools.WaterCrops:
			_water_hit()
		DataTypes.Tools.PlantCorn:
			_plant_hit("corn")
		DataTypes.Tools.PlantTomato:
			_plant_hit("tomato")
		DataTypes.Tools.Pickaxe:
			_pickaxe_hit()
		DataTypes.Tools.Sickle:
			_sickle_hit()
		DataTypes.Tools.FishingRod:
			_fishing_hit()
		_:
			pass  # No tool or unhandled tool


# =====================================================
# TOOL-SPECIFIC HIT HANDLERS
# =====================================================

func _axe_hit() -> void:
	_call_method_on_overlaps("chop", [hit_damage])


func _pickaxe_hit() -> void:
	_call_method_on_overlaps("mine", [hit_damage])


func _till_hit() -> void:
	_call_method_on_overlaps("till")


func _water_hit() -> void:
	_call_method_on_overlaps("water")


func _plant_hit(crop_name: String) -> void:
	_call_method_on_overlaps("plant", [crop_name])


func _sickle_hit() -> void:
	_call_method_on_overlaps("harvest")


func _fishing_hit() -> void:
	_call_method_on_overlaps("fish")


# =====================================================
# HELPER FUNCTIONS
# =====================================================

## Call a method on all overlapping bodies (if they have it)
func _call_method_on_overlaps(method_name: String, args: Array = []) -> void:
	for body in get_overlapping_bodies():
		if body.has_method(method_name):
			body.callv(method_name, args)


## Invalidate cache when overlaps change
func _on_area_cache_changed(_area: Area2D) -> void:
	_cache_valid = false


func _on_body_cache_changed(_body: Node2D) -> void:
	_cache_valid = false


## Get cached overlapping bodies
func get_cached_overlaps() -> Array[Node2D]:
	if not _cache_valid:
		_cached_overlaps.clear()
		_cached_overlaps.assign(get_overlapping_bodies())
		_cache_valid = true
	return _cached_overlaps


## Check if hitting anything
func is_hitting_something() -> bool:
	return not get_overlapping_bodies().is_empty()
