extends HBoxContainer

@onready var item_icon: TextureRect = $Icon
@onready var ingredient_name: Label = $VBoxContainer/Name
@onready var amount_label: Label = $VBoxContainer/Amount


func setup_ingredient(item_name: String, required: int, has: int):
	"""Setup the ingredient display."""
	# Set icon
	item_icon.texture = DataTypes.get_icon(item_name)
	
	# Set name
	ingredient_name.text = DataTypes.get_display_name(item_name)
	
	# Set amount with color coding
	amount_label.text = str(has) + " / " + str(required)
	
	# Color code based on if we have enough
	if has >= required:
		amount_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		amount_label.add_theme_color_override("font_color", Color.RED)
