extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Asegúrate de que el nombre del nodo hijo coincida (ej. $AnimatedSprite2D)
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_update_animations(direction)


func _update_animations(direction: float) -> void:
	# Voltear el sprite a la izquierda o derecha según hacia dónde se mueva
	if direction > 0:
		anim_sprite.flip_h = false
	elif direction < 0:
		anim_sprite.flip_h = true

	# Seleccionar animación según el estado del personaje
	if not is_on_floor():
		anim_sprite.play("jump")
	elif abs(velocity.x) > 0:
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")
