extends Button

@onready var icon_texture: TextureRect = $IconTexture
@onready var count_label: Label = $CountLabel
@onready var selection_indicator: Panel = $SelectionIndicator

var item_name: String = ""
var item_count: int = 0
var slot_index: int = 0
var associated_tool: DataTypes.Tools = DataTypes.Tools.None
var is_selected: bool = false  # Track if this slot is selected (different from tool being equipped)

# Map item names to their corresponding tools
const ITEM_TO_TOOL := {
	"axewood": DataTypes.Tools.AxeWood,
	"hoe": DataTypes.Tools.TillGround,
	"wateringcan": DataTypes.Tools.WaterCrops,
	"cornseed": DataTypes.Tools.PlantCorn,
	"tomatoseed": DataTypes.Tools.PlantTomato,
	# Common variations
	"axe": DataTypes.Tools.AxeWood,
	"watering_can": DataTypes.Tools.WaterCrops,
	"corn_seed": DataTypes.Tools.PlantCorn,
	"tomato_seed": DataTypes.Tools.PlantTomato,
}

func _ready() -> void:
	# Connect the button press signal
	pressed.connect(_on_pressed)
	
	# Listen for tool selection changes to update visual indicator
	if ToolManager:
		ToolManager.tool_selected.connect(_on_tool_selected)

func set_slot_data(slot_idx: int, name: String, count: int, texture: Texture2D) -> void:
	slot_index = slot_idx
	item_name = name
	item_count = count
	
	# Set the icon
	if texture:
		icon_texture.texture = texture
		icon_texture.visible = true
	else:
		icon_texture.texture = null
		icon_texture.visible = false
	
	# Set the count label
	if count > 1:
		count_label.text = str(count)
		count_label.visible = true
	else:
		count_label.visible = false
	
	# Determine the associated tool (case-insensitive lookup)
	associated_tool = ITEM_TO_TOOL.get(item_name.to_lower(), DataTypes.Tools.None)
	
	# Update selection indicator
	update_selection_indicator()

func _on_pressed() -> void:
	# If this slot has a tool, equip it
	if associated_tool != DataTypes.Tools.None:
		ToolManager.select_tool(associated_tool)
	else:
		# If it's not a tool, unequip the current tool
		ToolManager.select_tool(DataTypes.Tools.None)

func _on_tool_selected(tool: DataTypes.Tools) -> void:
	update_selection_indicator()

func set_selected(selected: bool) -> void:
	is_selected = selected
	update_selection_indicator()

func update_selection_indicator() -> void:
	# Show indicator if this slot is selected OR if this slot's tool is equipped
	var show_indicator := false
	
	if is_selected:
		# Slot is selected - always show indicator (even for non-tools)
		show_indicator = true
	elif associated_tool != DataTypes.Tools.None and associated_tool == ToolManager.selected_tool:
		# This tool is equipped (even if another slot is selected)
		show_indicator = true
	
	selection_indicator.visible = show_indicator
