extends CanvasLayer

@onready var hotbar_container: HBoxContainer = $Panel/HotbarContainer

# Preload the hotbar slot scene
var hotbar_slot_scene = preload("res://scenes/ui/hotbar_slot.tscn")

# Map item names to icons (match this with your actual icon paths)
var item_icons := {
	"corn": preload("res://scenes/ui/icons/corn_icon.tres"),
	"tomato": preload("res://scenes/ui/icons/tomato_icon.tres"),
	"egg": preload("res://scenes/ui/icons/egg_icon.tres"),
	"stone": preload("res://scenes/ui/icons/stone_icon.tres"),
	"log": preload("res://scenes/ui/icons/log_icon.tres"),
	"milk": preload("res://scenes/ui/icons/milk_icon.tres"),
	"axewood": preload("res://scenes/ui/icons/axewood_icon.tres"),
	# Add more tool icons here as needed:
	# "hoe": preload("res://scenes/ui/icons/hoe_icon.tres"),
	# "wateringcan": preload("res://scenes/ui/icons/wateringcan_icon.tres"),
	# "cornseed": preload("res://scenes/ui/icons/cornseed_icon.tres"),
	# "tomatoseed": preload("res://scenes/ui/icons/tomatoseed_icon.tres"),
}

const HOTBAR_SIZE := 9  # Number of hotbar slots
var selected_slot_index := -1  # Track which hotbar slot is currently selected

func _ready() -> void:
	# Connect to inventory changes
	if InventoryManager:
		InventoryManager.inventory_changed.connect(refresh_hotbar)
	
	# Initial hotbar setup
	refresh_hotbar()

func refresh_hotbar() -> void:
	# Clear existing slots
	for child in hotbar_container.get_children():
		child.queue_free()
	
	# Get the first HOTBAR_SIZE items from inventory
	var displayed_items: Array = []
	for i in range(min(HOTBAR_SIZE, InventoryManager.SLOT_COUNT)):
		var slot_data = InventoryManager.inventory[i]
		displayed_items.append(slot_data)
	
	# Create hotbar slots
	for i in range(HOTBAR_SIZE):
		var slot = hotbar_slot_scene.instantiate()
		hotbar_container.add_child(slot)
		
		if i < displayed_items.size() and displayed_items[i] != null:
			var item_data = displayed_items[i]
			var item_name: String = item_data.name
			var item_count: int = item_data.count
			var icon: Texture2D = item_icons.get(item_name.to_lower(), null)
			
			slot.set_slot_data(i, item_name, item_count, icon)
		else:
			# Empty slot
			slot.set_slot_data(i, "", 0, null)
	
	# Wait one frame for all slots to be fully initialized
	await get_tree().process_frame
	
	# Now restore the selection
	_update_all_slot_selections()

func _unhandled_input(event: InputEvent) -> void:
	# Allow number keys 1-9 to select hotbar slots
	if event is InputEventKey and event.pressed and not event.echo:
		var slot_index := -1
		match event.keycode:
			KEY_1: slot_index = 0
			KEY_2: slot_index = 1
			KEY_3: slot_index = 2
			KEY_4: slot_index = 3
			KEY_5: slot_index = 4
			KEY_6: slot_index = 5
			KEY_7: slot_index = 6
			KEY_8: slot_index = 7
			KEY_9: slot_index = 8
		
		if slot_index >= 0:
			_select_hotbar_slot(slot_index)
			get_viewport().set_input_as_handled()

func _select_hotbar_slot(slot_index: int) -> void:
	if slot_index >= hotbar_container.get_child_count():
		return
	
	# Update the selected slot index
	selected_slot_index = slot_index
	
	# Get the slot and trigger its action
	var slot = hotbar_container.get_child(slot_index)
	if slot and slot.has_method("_on_pressed"):
		slot._on_pressed()
	
	# Update visual selection for all slots
	_update_all_slot_selections()

func _update_all_slot_selections() -> void:
	for i in range(hotbar_container.get_child_count()):
		var slot = hotbar_container.get_child(i)
		if slot and slot.has_method("set_selected"):
			slot.set_selected(i == selected_slot_index)
