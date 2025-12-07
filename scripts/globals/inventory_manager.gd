# InventoryManager.gd
# Autoload / Singleton

extends Node

signal inventory_changed

# ---------- CONFIG ----------
const SLOT_COUNT: int = 24    # Total inventory slots
const MAX_STACK: int = 99     # Maximum stack per slot

# ---------- INVENTORY DATA ----------
# Each slot is either:
# null (empty)
# or a Dictionary: { "name": String, "count": int }
var inventory: Array = []

func _ready() -> void:
	# Initialize empty slots
	inventory.resize(SLOT_COUNT)
	for i in range(SLOT_COUNT):
		inventory[i] = null

# ---------- ADD ITEM ----------
func add_collectable(item_name: String, amount: int = 1) -> bool:
	var remaining := amount

	# 1️⃣ Try stacking into existing slots
	for i in range(SLOT_COUNT):
		var slot = inventory[i]
		if slot != null and slot.name == item_name and slot.count < MAX_STACK:
			var space_left = MAX_STACK - slot.count
			var to_add = min(space_left, remaining)
			slot.count += to_add
			remaining -= to_add

			if remaining <= 0:
				inventory_changed.emit()
				return true

	# 2️⃣ Put into empty slots
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			var to_add = min(MAX_STACK, remaining)
			inventory[i] = { "name": item_name, "count": to_add }
			remaining -= to_add

			if remaining <= 0:
				inventory_changed.emit()
				return true

	# 3️⃣ Inventory full
	inventory_changed.emit()
	return false

# ---------- REMOVE ITEM ----------
func remove_collectable(item_name: String, amount: int = 1) -> bool:
	var remaining := amount

	for i in range(SLOT_COUNT):
		var slot = inventory[i]
		if slot != null and slot.name == item_name:
			var to_remove = min(slot.count, remaining)
			slot.count -= to_remove
			remaining -= to_remove

			if slot.count <= 0:
				inventory[i] = null

			if remaining <= 0:
				inventory_changed.emit()
				return true

	inventory_changed.emit()
	return false

# ---------- GET TOTAL COUNT OF ITEM ----------
func get_item_count(item_name: String) -> int:
	var total := 0
	for slot in inventory:
		if slot != null and slot.name == item_name:
			total += slot.count
	return total

# ---------- CHECK IF INVENTORY HAS SPACE ----------
func has_space_for(item_name: String, amount: int = 1) -> bool:
	var free_space := 0

	for slot in inventory:
		if slot == null:
			free_space += MAX_STACK
		elif slot.name == item_name:
			free_space += MAX_STACK - slot.count

	return free_space >= amount

# ---------- GET TOTALS FOR UI (Dictionary) ----------
func get_inventory_totals() -> Dictionary:
	var totals := {}
	for slot in inventory:
		if slot != null:
			if totals.has(slot.name):
				totals[slot.name] += slot.count
			else:
				totals[slot.name] = slot.count
	return totals
