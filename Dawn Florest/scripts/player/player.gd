extends CharacterBody2D
class_name Player

@onready var player_sprite = get_node("Texture")


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var player_gravity = 100

var jump_count:int = 0
var landing:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	horizontal_movememt_env()
	vertical_movement_env()
	gravidade(delta)
	
	move_and_slide()
	player_sprite.animate(velocity)
	

func  horizontal_movememt_env() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func vertical_movement_env() -> void:
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_just_pressed("ui_select") and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY
	
func gravidade(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
