# InventoryManager.gd
# Autoload / Singleton
# Optimized version with better performance and cleaner structure

extends Node

signal inventory_changed
signal tool_broken(slot_index: int, item_name: String)

# ---------- CONFIG ----------
const SLOT_COUNT: int = 24

# ---------- INVENTORY DATA ----------
var inventory: Array = []

# Cache for quick lookups - cleared when inventory changes
var _item_count_cache: Dictionary = {}
var _cache_dirty: bool = true


func _ready() -> void:
	inventory.resize(SLOT_COUNT)
	inventory.fill(null)  # More efficient than loop


# =====================================================
# ADD ITEM - OPTIMIZED
# =====================================================
func add_collectable(item_name: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
		
	var item_data := _get_item_data(item_name)
	
	var remaining := amount
	var has_durability: bool = item_data.has_durability
	var max_stack: int = item_data.max_stack
	
	# Durable items NEVER stack
	if has_durability:
		remaining = _add_durable_item(item_name, item_data)
	else:
		# Stackable items - try existing stacks first, then empty slots
		remaining = _add_stackable_item(item_name, remaining, max_stack)
	
	if remaining < amount:
		_mark_dirty()
		return remaining == 0
	
	return false


func _add_durable_item(item_name: String, item_data: Dictionary) -> int:
	var empty_slot := _find_empty_slot()
	if empty_slot == -1:
		return 1
	
	inventory[empty_slot] = {
		"name": item_name,
		"count": 1,
		"durability": item_data.max_durability,
		"max_durability": item_data.max_durability
	}
	return 0


func _add_stackable_item(item_name: String, remaining: int, max_stack: int) -> int:
	# Fill existing stacks first
	for i in SLOT_COUNT:
		if remaining <= 0:
			break
		var slot = inventory[i]
		if slot != null and slot.name == item_name and slot.count < max_stack:
			var space: int = max_stack - slot.count
			var to_add: int = mini(space, remaining)
			slot.count += to_add
			remaining -= to_add
	
	# Create new stacks in empty slots
	while remaining > 0:
		var empty_slot := _find_empty_slot()
		if empty_slot == -1:
			break
		
		var to_add: int = mini(max_stack, remaining)
		inventory[empty_slot] = {
			"name": item_name,
			"count": to_add
		}
		remaining -= to_add
	
	return remaining


# =====================================================
# DAMAGE TOOL - OPTIMIZED
# =====================================================
func damage_tool(slot_index: int, amount: int = 1) -> void:
	# Validate slot index
	if not _is_valid_slot(slot_index):
		return
	
	var slot = inventory[slot_index]
	if slot == null or not slot.has("durability"):
		return
	
	# Apply damage
	slot.durability -= amount
	
	# Check if tool broke
	if slot.durability <= 0:
		var item_name: String = slot.name
		inventory[slot_index] = null
		
		# Unequip if this was the equipped tool
		if ToolManager.selected_slot_index == slot_index:
			ToolManager.select_tool(DataTypes.Tools.None, -1)
		
		tool_broken.emit(slot_index, item_name)
	
	_mark_dirty()


# =====================================================
# REMOVE ITEM - OPTIMIZED
# =====================================================
func remove_collectable(item_name: String, amount: int = 1) -> bool:
	if amount <= 0:
		return true
		
	var remaining := amount
	
	for i in SLOT_COUNT:
		if remaining <= 0:
			break
			
		var slot = inventory[i]
		if slot != null and slot.name == item_name:
			var to_remove: int = mini(slot.count, remaining)
			slot.count -= to_remove
			remaining -= to_remove
			
			if slot.count <= 0:
				inventory[i] = null
	
	var success := remaining == 0
	if amount > remaining:  # At least some items were removed
		_mark_dirty()
	
	return success


# =====================================================
# QUERY HELPERS - OPTIMIZED WITH CACHING
# =====================================================
func get_item_count(item_name: String) -> int:
	if _cache_dirty:
		_rebuild_cache()
	return _item_count_cache.get(item_name, 0)


func has_item(item_name: String) -> bool:
	return get_item_count(item_name) > 0


func has_space_for(item_name: String, amount: int = 1) -> bool:
	var item_data := _get_item_data(item_name)
	
	var has_durability: bool = item_data.has_durability
	var max_stack: int = item_data.max_stack
	var available_space := 0
	
	for slot in inventory:
		if slot == null:
			available_space += max_stack if not has_durability else 1
		elif not has_durability and slot.name == item_name:
			available_space += max_stack - slot.count
	
	return available_space >= amount


func get_slot_data(slot_index: int) -> Dictionary:
	if _is_valid_slot(slot_index):
		return inventory[slot_index] if inventory[slot_index] != null else {}
	return {}


func get_inventory_totals() -> Dictionary:
	if _cache_dirty:
		_rebuild_cache()
	return _item_count_cache.duplicate()


# =====================================================
# UTILITY FUNCTIONS
# =====================================================
func _find_empty_slot() -> int:
	for i in SLOT_COUNT:
		if inventory[i] == null:
			return i
	return -1


func _is_valid_slot(slot_index: int) -> bool:
	return slot_index >= 0 and slot_index < SLOT_COUNT


func _get_item_data(item_name: String) -> Dictionary:
	var data := DataTypes.get_item_data(item_name)
	if data.is_empty():
		# Return default values instead of empty dictionary
		return {
			"has_durability": false,
			"max_durability": 100,
			"max_stack": 99
		}
	
	return {
		"has_durability": data.get("has_durability", false),
		"max_durability": data.get("max_durability", 100),
		"max_stack": data.get("max_stack", 99)
	}


func _rebuild_cache() -> void:
	_item_count_cache.clear()
	for slot in inventory:
		if slot != null:
			var item_name: String = slot.name
			_item_count_cache[item_name] = _item_count_cache.get(item_name, 0) + slot.count
	_cache_dirty = false


func _mark_dirty() -> void:
	_cache_dirty = true
	inventory_changed.emit()


# =====================================================
# DEBUG HELPERS
# =====================================================
func print_inventory() -> void:
	print("=== INVENTORY ===")
	for i in SLOT_COUNT:
		if inventory[i] != null:
			var slot = inventory[i]
			var durability_str := ""
			if slot.has("durability"):
				durability_str = " [%d/%d]" % [slot.durability, slot.max_durability]
			print("Slot %d: %s x%d%s" % [i, slot.name, slot.count, durability_str])
