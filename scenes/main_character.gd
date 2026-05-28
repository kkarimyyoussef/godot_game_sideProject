extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var tile_map: TileMap = $"../TextureRect/TileMap"
@onready var box: RigidBody2D = $"../Box"
@onready var collectable: Area2D = $"../collectable"
var spawn_position = Vector2(1, 1)

# similar to the update function
func _physics_process(delta: float) -> void:
	
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"	
		
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()
	
	var isleft = velocity.x < 0
	sprite_2d.flip_h = isleft
	
	var tile_pos = tile_map.local_to_map(position)
	if tile_pos.y > 40:
		position = spawn_position
	
	if collectable.has_overlapping_bodies():
		collectable.visible = false 
		
	if position.distance_to(Vector2(21, 12)) < 10:
		box.gravity_scale = 1
