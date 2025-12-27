extends CanvasLayer

@onready var inventory_panel: Panel = $InventoryPanel
@onready var grid: GridContainer = $InventoryPanel/MarginContainer/GridContainer

# Preload the slot scene
@onready var slot_scene = preload("res://scenes/ui/inventory_slot.tscn")

# ❌ REMOVED: Manual icon mapping - now uses DataTypes.get_icon()

const TOTAL_SLOTS := 20


func _ready():
	# Configure grid appearance
	grid.columns = 5  # Adjust number of columns as desired
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	
	# Connect to inventory system
	InventoryManager.inventory_changed.connect(refresh_inventory_ui)
	refresh_inventory_ui()
	inventory_panel.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("inventory_toggle"):
		inventory_panel.visible = !inventory_panel.visible


func refresh_inventory_ui():
	# Clear previous slots
	for child in grid.get_children():
		child.queue_free()
	
	var totals = InventoryManager.get_inventory_totals()
	var item_list = totals.keys()
	
	# Create exactly 20 slots
	for i in range(TOTAL_SLOTS):
		var slot = slot_scene.instantiate()
		grid.add_child(slot)
		
		if i < item_list.size():
			# Assign item to this slot
			var item_name = item_list[i]
			var amount = totals[item_name]
			
			# ✨ Use DataTypes to get icon automatically
			var icon_texture: Texture2D = DataTypes.get_icon(item_name)
			
			slot.set_item(item_name, amount, icon_texture)
		else:
			# Empty slot
			slot.set_item("", 0, null)
