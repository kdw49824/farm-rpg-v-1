class_name Player
extends CharacterBody2D
## Main player controller with tool management

signal tool_changed(new_tool: DataTypes.Tools, slot_index: int)

@export_group("Components")
@onready var hit_component: HitComponent = $HitComponent

@export_group("Tool State")
var current_tool: DataTypes.Tools = DataTypes.Tools.None
var equipped_slot_index: int = -1

@export_group("Movement")
var player_direction: Vector2 = Vector2.DOWN

# Optimization: Cache tool state to avoid redundant updates
var _last_tool: DataTypes.Tools = DataTypes.Tools.None


func _ready() -> void:
	_setup_tool_system()


func _setup_tool_system() -> void:
	if ToolManager:
		ToolManager.tool_selected.connect(_on_tool_selected)
	else:
		push_error("ToolManager not found! Make sure it's an autoload.")


func _on_tool_selected(tool: DataTypes.Tools, slot_index: int) -> void:
	# Only update if tool actually changed (avoid redundant signal emissions)
	if current_tool != tool or equipped_slot_index != slot_index:
		current_tool = tool
		equipped_slot_index = slot_index
		
		# Update hit component
		if hit_component:
			hit_component.current_tool = tool
		
		tool_changed.emit(tool, slot_index)
		_last_tool = tool


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		use_current_tool()


func use_current_tool() -> void:
	# Early exit if no tool equipped
	if current_tool == DataTypes.Tools.None:
		return
	
	# Verify we still have the tool (it might have broken)
	if not _verify_tool_still_equipped():
		return
	
	# Use the tool
	if hit_component:
		hit_component.try_hit()


## Verify the equipped tool still exists in inventory
func _verify_tool_still_equipped() -> bool:
	# Check if slot is still valid
	if equipped_slot_index < 0:
		return false
	
	# Check if item still exists in that slot
	var slot_data := InventoryManager.get_slot_data(equipped_slot_index)
	if slot_data.is_empty():
		# Tool was removed/broken - unequip
		_unequip_tool()
		return false
	
	return true


func _unequip_tool() -> void:
	current_tool = DataTypes.Tools.None
	equipped_slot_index = -1
	if hit_component:
		hit_component.current_tool = DataTypes.Tools.None
	tool_changed.emit(DataTypes.Tools.None, -1)


## Get current tool damage (for UI display)
func get_current_tool_damage() -> int:
	if equipped_slot_index < 0:
		return 0
	
	var slot_data := InventoryManager.get_slot_data(equipped_slot_index)
	if slot_data.is_empty():
		return 0
	
	return slot_data.get("durability", 0)


## Check if player has a tool equipped
func has_tool_equipped() -> bool:
	return current_tool != DataTypes.Tools.None


## Check if player has a specific type of tool
func has_tool_type(tool: DataTypes.Tools) -> bool:
	return current_tool == tool
