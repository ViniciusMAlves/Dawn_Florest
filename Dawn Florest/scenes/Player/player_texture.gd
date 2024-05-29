extends Sprite2D
class_name PlayerTexture

var normal_attack: bool = false
var shield_off: bool = false
var chouching_off: bool = false
var suffix: String = "_right"

@export var animation_path: AnimationPlayer
@export var player: CharacterBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if player.attacking or player.defending or player.crouching:
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing:
		animation_path.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	

func verify_position(direction: Vector2)-> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"

func action_behavior() -> void:
	if player.attacking and normal_attack:
		animation_path.play("attack" + suffix)
	elif  player.defending and shield_off:
		animation_path.play("shield")
		shield_off = false
	elif player.crouching and chouching_off:
		animation_path.play("crouch")
		chouching_off = false

func vertical_behavior(direction: Vector2)-> void:
	if direction.y > 0:
		player.landing = true
		animation_path.play("fall")
	elif direction.y < 0:
		animation_path.play("jump")

func horizontal_behavior(direction: Vector2)-> void:
	if direction.x != 0:
		animation_path.play("run")
	else:
		animation_path.play("idle")


func _on_animation_finished(anim_name):
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
			
		"attack_left":
			normal_attack = false
			player.attacking = false
			
		"attack_right":
			normal_attack = false
			player.attacking = false
