# InventoryManager.gd
# Autoload / Singleton

extends Node

signal inventory_changed

# ---------- CONFIG ----------
const SLOT_COUNT: int = 24

# ---------- INVENTORY DATA ----------
# Each slot is either:
# null
# or {
#   "name": String,
#   "count": int,
#   "durability": int,
#   "max_durability": int
# }
var inventory: Array = []

func _ready() -> void:
	inventory.resize(SLOT_COUNT)
	for i in range(SLOT_COUNT):
		inventory[i] = null


# =====================================================
# ADD ITEM
# =====================================================
func add_collectable(item_name: String, amount: int = 1) -> bool:
	var remaining := amount
	var has_durability := DataTypes.has_durability(item_name)
	var max_stack := DataTypes.get_max_stack(item_name)

	# 🔒 Durable items NEVER stack
	if has_durability:
		for i in range(SLOT_COUNT):
			if inventory[i] == null:
				inventory[i] = {
					"name": item_name,
					"count": 1,
					"durability": DataTypes.get_max_durability(item_name),
					"max_durability": DataTypes.get_max_durability(item_name)
				}
				inventory_changed.emit()
				return true
		return false

	# 📦 Stackable items
	for i in range(SLOT_COUNT):
		var slot = inventory[i]
		if slot != null and slot.name == item_name and slot.count < max_stack:
			var space : int = max_stack - slot.count
			var to_add : int = min(space, remaining)
			slot.count += to_add
			remaining -= to_add
			if remaining <= 0:
				inventory_changed.emit()
				return true

	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			var to_add : int = min(max_stack, remaining)
			inventory[i] = {
				"name": item_name,
				"count": to_add
			}
			remaining -= to_add
			if remaining <= 0:
				inventory_changed.emit()
				return true

	inventory_changed.emit()
	return false


# =====================================================
# DAMAGE TOOL (CORE FUNCTION)
# =====================================================
func damage_tool(slot_index: int, amount: int = 1) -> void:
	if slot_index < 0 or slot_index >= SLOT_COUNT:
		return

	var slot = inventory[slot_index]
	if slot == null:
		return

	if not slot.has("durability"):
		return

	slot.durability -= amount

	if slot.durability <= 0:
		inventory[slot_index] = null  # 🪓 TOOL BROKE
		
		# Unequip the tool if it was equipped in this slot
		if ToolManager.selected_slot_index == slot_index:
			ToolManager.select_tool(DataTypes.Tools.None, -1)

	inventory_changed.emit()


# =====================================================
# REMOVE ITEM
# =====================================================
func remove_collectable(item_name: String, amount: int = 1) -> bool:
	var remaining := amount

	for i in range(SLOT_COUNT):
		var slot = inventory[i]
		if slot != null and slot.name == item_name:
			var to_remove : int = min(slot.count, remaining)
			slot.count -= to_remove
			remaining -= to_remove

			if slot.count <= 0:
				inventory[i] = null

			if remaining <= 0:
				inventory_changed.emit()
				return true

	inventory_changed.emit()
	return false


# =====================================================
# QUERY HELPERS
# =====================================================
func get_item_count(item_name: String) -> int:
	var total := 0
	for slot in inventory:
		if slot != null and slot.name == item_name:
			total += slot.count
	return total

func has_space_for(item_name: String, amount: int = 1) -> bool:
	var has_durability := DataTypes.has_durability(item_name)
	var max_stack := DataTypes.get_max_stack(item_name)
	var free := 0

	for slot in inventory:
		if slot == null:
			free += 1 if has_durability else max_stack
		elif not has_durability and slot.name == item_name:
			free += max_stack - slot.count

	return free >= amount


func get_inventory_totals() -> Dictionary:
	var totals := {}
	for slot in inventory:
		if slot != null:
			totals[slot.name] = totals.get(slot.name, 0) + slot.count
	return totals
