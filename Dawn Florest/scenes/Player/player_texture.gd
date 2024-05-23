extends Sprite2D
class_name PlayerTexture

@export var animation_path: AnimationPlayer
@export var player: CharacterBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if direction.y != 0:
		vertical_behavior(direction)
	elif player.landing:
		animation_path.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	

func verify_position(direction: Vector2)-> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

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
