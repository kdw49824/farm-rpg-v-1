extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/Corn/CornLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	on_inventory_changed() # ✅ Force refresh on open


func on_inventory_changed() -> void:
	# ✅ Pull totals from slot-based inventory
	var inventory: Dictionary = InventoryManager.get_inventory_totals()

	# ✅ Default everything to 0 (prevents stale numbers)
	log_label.text = "0"
	stone_label.text = "0"
	corn_label.text = "0"
	tomato_label.text = "0"
	milk_label.text = "0"
	egg_label.text = "0"

	# ✅ Now safely update only what exists
	if inventory.has("log"):
		log_label.text = str(inventory["log"])

	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])

	if inventory.has("corn"):
		corn_label.text = str(inventory["corn"])

	if inventory.has("tomato"):
		tomato_label.text = str(inventory["tomato"])

	if inventory.has("milk"):
		milk_label.text = str(inventory["milk"])

	if inventory.has("egg"):
		egg_label.text = str(inventory["egg"])
