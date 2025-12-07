extends CanvasLayer  # Attach to InventoryUI node

@onready var inventory_panel: Panel = $InventoryPanel
@onready var grid: GridContainer = $InventoryPanel/GridContainer

# Map item names to icons (optional, for Button icons)
var item_icons: Dictionary = {
	"corn": preload("res://scenes/ui/icons/corn_icon.tres"),
	"tomato": preload("res://scenes/ui/icons/tomato_icon.tres")
}

func _ready() -> void:
	InventoryManager.inventory_changed.connect(refresh_inventory_ui)
	refresh_inventory_ui()
	inventory_panel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_toggle"):
		inventory_panel.visible = not inventory_panel.visible

func refresh_inventory_ui() -> void:
	# Clear existing slots
	for child in grid.get_children():
		child.queue_free()

	var totals: Dictionary = InventoryManager.get_inventory_totals()

	for item_name in totals.keys():
		var count = totals[item_name]

		# Create a Button slot
		var slot_button = Button.new()
		slot_button.name = item_name
		slot_button.custom_minimum_size = Vector2(64, 64)
		slot_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot_button.size_flags_vertical = Control.SIZE_EXPAND_FILL

		# Apply solid color background using StyleBoxFlat
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.2, 0.2)  # dark gray
		slot_button.add_theme_stylebox_override("normal", style)
		slot_button.add_theme_stylebox_override("hover", style)
		slot_button.add_theme_stylebox_override("pressed", style)

		# Optional: set an icon if available
		if item_icons.has(item_name):
			slot_button.icon = item_icons[item_name]

		# Add a Label for item count
		var label = Label.new()
		label.text = str(count)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		label.size_flags_horizontal = Control.SIZE_FILL
		label.size_flags_vertical = Control.SIZE_FILL
		slot_button.add_child(label)

		# Add the slot to the grid
		grid.add_child(slot_button)
