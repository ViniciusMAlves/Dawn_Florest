extends CharacterBody2D
class_name Player

@onready var player_sprite = get_node("Texture")


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var player_gravity = 100

var jump_count:int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var can_track_input: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	horizontal_movememt_env()
	vertical_movement_env()
	gravidade(delta)
	action_env()
	
	move_and_slide()
	player_sprite.animate(velocity)
	

func  horizontal_movememt_env() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if (not can_track_input) or attacking:
		velocity.x = 0
		return
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func vertical_movement_env() -> void:
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_just_pressed("jump") and jump_count < 2 and can_track_input and (not attacking):
		jump_count += 1
		velocity.y = JUMP_VELOCITY

func action_env() -> void:
	attack()
	crounch()
	defense()

func attack() -> void:
	var attack_condition = (not attacking) and (not crouching) and (not defending)
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true

func crounch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.chouching_off = true

func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true

func gravidade(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
