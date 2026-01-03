extends Button

@onready var item_icon: TextureRect = $HBoxContainer/Icon
@onready var recipe_name: Label = $HBoxContainer/VBoxContainer/Name
@onready var can_craft_indicator: ColorRect = $CanCraftIndicator

var recipe_id := ""
var recipe_info := {}


func setup_recipe(info: Dictionary):
	"""Setup the button with recipe information."""
	recipe_info = info
	recipe_id = info.get("recipe_id", "")
	
	# Set icon
	var result_icon = info.get("result_icon")
	if result_icon:
		item_icon.texture = result_icon
	
	# Set name
	var display_name = info.get("result_display_name", "")
	var amount = info.get("result_amount", 1)
	if amount > 1:
		display_name += " x" + str(amount)
	recipe_name.text = display_name
	
	# Update craftable status
	update_craftable_status()


func update_craftable_status():
	"""Update the visual indicator of whether this can be crafted."""
	var can_craft = CraftingManager.can_craft(recipe_id)
	
	if can_craft_indicator:
		can_craft_indicator.visible = can_craft
		can_craft_indicator.color = Color.GREEN if can_craft else Color.RED
