class_name HurtComponent
extends Node2D
## Component that handles receiving damage and tool durability
## Attach to objects that can be interacted with (trees, rocks, etc.)

signal hurt(damage: int)
signal destroyed

@export_group("Tool Requirements")
@export var required_tool: DataTypes.Tools = DataTypes.Tools.None
@export var durability_cost: int = 1

@export_group("References")
@export var player: Player  # Optional - will auto-find if not assigned

@export_group("Health")
@export var max_health: int = 3
var current_health: int = max_health

var _player_cached: bool = false


func _ready() -> void:
	_cache_player_reference()


## Cache player reference once instead of checking every hit
func _cache_player_reference() -> void:
	if player != null:
		_player_cached = true
		return
	
	# Auto-find player from group
	player = get_tree().get_first_node_in_group("player") as Player
	_player_cached = player != null
	
	if not _player_cached:
		push_warning("HurtComponent on %s: No player found. Durability system will not work." % get_parent().name)


func _on_area_entered(area: Area2D) -> void:
	# Quick type check
	var hit_component := area as HitComponent
	if hit_component == null:
		return
	
	# Validate tool requirement
	if required_tool != DataTypes.Tools.None and required_tool != hit_component.current_tool:
		return
	
	# Process the hit
	_process_hit(hit_component.hit_damage)
	
	# Damage the tool
	_damage_player_tool()


func _process_hit(damage: int) -> void:
	current_health -= damage
	hurt.emit(damage)
	
	if current_health <= 0:
		destroyed.emit()
		_handle_destruction()


func _damage_player_tool() -> void:
	if not _player_cached:
		return
	
	# Direct call is faster than signal
	InventoryManager.damage_tool(player.equipped_slot_index, durability_cost)


func _handle_destruction() -> void:
	# Override this in inherited scripts for custom destruction behavior
	# For example: spawn loot, play animation, etc.
	pass


## Reset health (useful for object pooling)
func reset() -> void:
	current_health = max_health


## Check if the component can be damaged by a specific tool
func can_be_damaged_by(tool: DataTypes.Tools) -> bool:
	return required_tool == DataTypes.Tools.None or required_tool == tool
