extends Node
## Singleton that manages tool selection and state across the game

signal tool_selected(tool: DataTypes.Tools, slot_index: int)
signal tool_enabled(tool: DataTypes.Tools)
signal tool_disabled(tool: DataTypes.Tools)

@export_group("Tool State")
var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_slot_index: int = -1

# Track which tools have been unlocked/enabled
var enabled_tools: Dictionary = {}

# Cache for quick tool availability checks
var _tool_cache_dirty: bool = true


func _ready() -> void:
	# Listen for inventory changes to update tool availability
	if InventoryManager:
		InventoryManager.inventory_changed.connect(_on_inventory_changed)
		InventoryManager.tool_broken.connect(_on_tool_broken)


## Select a tool to use
func select_tool(tool: DataTypes.Tools, slot_index: int) -> void:
	# Avoid redundant emissions
	if selected_tool == tool and selected_slot_index == slot_index:
		return
	
	var previous_tool := selected_tool
	selected_tool = tool
	selected_slot_index = slot_index
	
	tool_selected.emit(tool, slot_index)


## Enable a tool button in UI
func enable_tool_button(tool: DataTypes.Tools) -> void:
	if not enabled_tools.get(tool, false):
		enabled_tools[tool] = true
		tool_enabled.emit(tool)


## Disable a tool button in UI
func disable_tool_button(tool: DataTypes.Tools) -> void:
	if enabled_tools.get(tool, false):
		enabled_tools[tool] = false
		tool_disabled.emit(tool)


## Check if a tool is currently enabled
func is_tool_enabled(tool: DataTypes.Tools) -> bool:
	return enabled_tools.get(tool, false)


## Check if a specific tool is currently selected
func is_tool_selected(tool: DataTypes.Tools) -> bool:
	return selected_tool == tool


## Get the currently selected tool
func get_selected_tool() -> DataTypes.Tools:
	return selected_tool


## Get the slot index of the currently selected tool
func get_selected_slot_index() -> int:
	return selected_slot_index


## Unequip current tool
func unequip_tool() -> void:
	select_tool(DataTypes.Tools.None, -1)


## Auto-equip first available tool of a specific type
func auto_equip_tool(tool: DataTypes.Tools) -> bool:
	# Search inventory for this tool type
	for i in InventoryManager.SLOT_COUNT:
		var slot_data := InventoryManager.get_slot_data(i)
		if slot_data.is_empty():
			continue
		
		var item_tool_type := DataTypes.get_tool_type(slot_data.name)
		if item_tool_type == tool:
			select_tool(tool, i)
			return true
	
	return false


## Check if player has any tool of a specific type in inventory
func has_tool_in_inventory(tool: DataTypes.Tools) -> bool:
	for i in InventoryManager.SLOT_COUNT:
		var slot_data := InventoryManager.get_slot_data(i)
		if slot_data.is_empty():
			continue
		
		var item_tool_type := DataTypes.get_tool_type(slot_data.name)
		if item_tool_type == tool:
			return true
	
	return false


# =====================================================
# PRIVATE FUNCTIONS
# =====================================================

func _on_inventory_changed() -> void:
	_tool_cache_dirty = true
	
	# If the currently equipped slot was emptied, unequip
	if selected_slot_index >= 0:
		var slot_data := InventoryManager.get_slot_data(selected_slot_index)
		if slot_data.is_empty():
			unequip_tool()


func _on_tool_broken(slot_index: int, item_name: String) -> void:
	# If the broken tool was equipped, unequip it
	if slot_index == selected_slot_index:
		unequip_tool()


# =====================================================
# DEBUG HELPERS
# =====================================================

func print_tool_state() -> void:
	print("=== TOOL MANAGER STATE ===")
	print("Selected Tool: ", selected_tool)
	print("Selected Slot: ", selected_slot_index)
	print("Enabled Tools: ", enabled_tools)
