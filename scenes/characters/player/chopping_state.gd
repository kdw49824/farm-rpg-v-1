extends NodeState
## Handles the chopping animation state for the player
## Optimized to reduce redundant checks and improve performance

@export_group("References")
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

# Cache animation names to avoid string lookups
const ANIM_CHOPPING_BACK := &"chopping_back"
const ANIM_CHOPPING_RIGHT := &"chopping_right"
const ANIM_CHOPPING_FRONT := &"chopping_front"
const ANIM_CHOPPING_LEFT := &"chopping_left"

# Cache collision positions to avoid recreating Vector2s
const POS_BACK := Vector2(0, -18)
const POS_RIGHT := Vector2(9, 0)
const POS_FRONT := Vector2(0, 3)
const POS_LEFT := Vector2(-9, 0)

var _has_triggered_hit: bool = false


func _ready() -> void:
	if hit_component_collision_shape:
		hit_component_collision_shape.disabled = true
		hit_component_collision_shape.position = Vector2.ZERO


func _on_process(_delta: float) -> void:
	pass


func _on_physics_process(_delta: float) -> void:
	pass


func _on_next_transitions() -> void:
	# Early exit optimization
	if animated_sprite_2d and not animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	_has_triggered_hit = false
	
	# Guard clause
	if not player or not animated_sprite_2d or not hit_component_collision_shape:
		push_error("ChoppingState: Missing required references!")
		transition.emit("Idle")
		return
	
	# Play appropriate animation and set collision position
	_setup_animation_and_collision()
	
	# Enable collision and trigger hit
	hit_component_collision_shape.disabled = false
	_trigger_hit()


func _on_exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	
	if hit_component_collision_shape:
		hit_component_collision_shape.disabled = true
	
	_has_triggered_hit = false


# =====================================================
# PRIVATE FUNCTIONS
# =====================================================

## Setup animation and collision based on player direction
func _setup_animation_and_collision() -> void:
	var direction := player.player_direction
	
	# Use match for better performance than if-elif chain
	match direction:
		Vector2.UP:
			animated_sprite_2d.play(ANIM_CHOPPING_BACK)
			hit_component_collision_shape.position = POS_BACK
		Vector2.RIGHT:
			animated_sprite_2d.play(ANIM_CHOPPING_RIGHT)
			hit_component_collision_shape.position = POS_RIGHT
		Vector2.DOWN:
			animated_sprite_2d.play(ANIM_CHOPPING_FRONT)
			hit_component_collision_shape.position = POS_FRONT
		Vector2.LEFT:
			animated_sprite_2d.play(ANIM_CHOPPING_LEFT)
			hit_component_collision_shape.position = POS_LEFT
		_:
			# Default to front if direction is invalid
			animated_sprite_2d.play(ANIM_CHOPPING_FRONT)
			hit_component_collision_shape.position = POS_FRONT


## Trigger the hit once per swing
func _trigger_hit() -> void:
	if _has_triggered_hit:
		return
	
	if player and player.hit_component:
		player.hit_component.try_hit()
		_has_triggered_hit = true
