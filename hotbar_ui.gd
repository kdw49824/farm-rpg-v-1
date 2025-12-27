extends CanvasLayer

@onready var hotbar_container: HBoxContainer = $Panel/HotbarContainer

var hotbar_slot_scene = preload("res://scenes/ui/hotbar_slot.tscn")

const HOTBAR_SIZE := 9
var selected_slot_index := -1

# Cache for slot references
var _slot_cache: Array = []


func _ready() -> void:
	if InventoryManager:
		InventoryManager.inventory_changed.connect(refresh_hotbar)
	
	refresh_hotbar()


func refresh_hotbar() -> void:
	# Clear existing slots
	for child in hotbar_container.get_children():
		child.queue_free()
	
	_slot_cache.clear()
	
	# Create hotbar slots
	for i in range(HOTBAR_SIZE):
		var slot = hotbar_slot_scene.instantiate()
		hotbar_container.add_child(slot)
		_slot_cache.append(slot)
		
		# Get data from inventory
		if i < InventoryManager.SLOT_COUNT:
			var slot_data = InventoryManager.inventory[i]
			
			if slot_data != null:
				var item_name: String = slot_data.name
				var item_count: int = slot_data.count
				
				# 🎯 Use DataTypes directly - no manual mapping needed!
				var icon: Texture2D = DataTypes.get_icon(item_name)
				
				slot.set_slot_data(i, item_name, item_count, icon)
			else:
				slot.set_slot_data(i, "", 0, null)
		else:
			slot.set_slot_data(i, "", 0, null)
	
	await get_tree().process_frame
	_update_all_slot_selections()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var slot_index := _get_slot_index_from_key(event.keycode)
		
		if slot_index >= 0:
			_select_hotbar_slot(slot_index)
			get_viewport().set_input_as_handled()


func _get_slot_index_from_key(keycode: int) -> int:
	match keycode:
		KEY_1: return 0
		KEY_2: return 1
		KEY_3: return 2
		KEY_4: return 3
		KEY_5: return 4
		KEY_6: return 5
		KEY_7: return 6
		KEY_8: return 7
		KEY_9: return 8
		_: return -1


func _select_hotbar_slot(slot_index: int) -> void:
	if slot_index >= _slot_cache.size():
		return
	
	selected_slot_index = slot_index
	
	var slot = _slot_cache[slot_index]
	if slot and slot.has_method("_on_pressed"):
		slot._on_pressed()
	
	_update_all_slot_selections()


func _update_all_slot_selections() -> void:
	for i in range(_slot_cache.size()):
		var slot = _slot_cache[i]
		if slot and slot.has_method("set_selected"):
			slot.set_selected(i == selected_slot_index)
