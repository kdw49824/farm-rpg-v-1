extends TextureButton

@onready var icon = $Icon

func set_item(texture: Texture2D):
	icon.texture = texture
	icon.visible = texture != null
