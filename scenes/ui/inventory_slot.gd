extends Button

@onready var icon_texture: TextureRect = $IconTexture
@onready var count_label: Label = $CountLabel

var item_name: String = ""
var count: int = 0

func _ready():
	pass
	
	# Configure icon display if it exists
	if icon_texture:
		icon_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let button handle clicks

func set_item(new_item_name: String, amount: int, texture: Texture2D):
	item_name = new_item_name
	count = amount
	
	# Set icon
	if icon_texture:
		if texture:
			icon_texture.texture = texture
			icon_texture.visible = true
		else:
			icon_texture.texture = null
			icon_texture.visible = false
	
	# Set count label
	if count_label:
		if count > 1:
			count_label.text = str(count)
			count_label.visible = true
		else:
			count_label.text = ""
			count_label.visible = false
