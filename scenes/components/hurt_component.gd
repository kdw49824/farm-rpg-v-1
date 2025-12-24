class_name HurtComponent
extends Node2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None
@export var durability_cost: int = 1
@export var player: Player   # assign in inspector (optional if using auto-find)

signal hurt(damage: int)

func _ready() -> void:
	# Auto-find player if not assigned
	if player == null:
		player = get_tree().get_first_node_in_group("player")

func _on_area_entered(area: Area2D) -> void:
	var hit_component := area as HitComponent
	if hit_component == null:
		return

	# Tool validation
	if tool != hit_component.current_tool:
		return

	# SUCCESSFUL HIT
	hurt.emit(hit_component.hit_damage)

	# 🪓 DAMAGE THE TOOL HERE
	if player:
		InventoryManager.damage_tool(
			player.equipped_slot_index,
			durability_cost
		)
